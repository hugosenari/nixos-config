use std

# Cache pop
def main [
 --bucket:   string = "nixstore",
 --creds:    string = "credentials",
 --endpoint: string = "https://q4n8.or.idrivee2-24.com",
 --profile:  string = "nixstore",
 --keep:     string = "(Fluggaenkoecchicebolsen)",
 --gcpath:   string = "/nix/var/nix/gcroots"
] {
  let hostname = (sys|get host.hostname)
  let remote_gc_roots = $"s3://($bucket)/gcroots/($hostname)/"
  let remote_gc_trash = $"s3://($bucket)/gctrash/"
  print $"Remote gcroots ($remote_gc_roots)"
  print $"Local  gcroots ($gcpath)"

  loop {
    let paths_remote = (s5cmd
      --credentials-file $creds
      --endpoint-url     $endpoint
      --profile          $profile
      ls $remote_gc_roots
      |lines
      |str replace "(^.+) ([^ ]+)" "$2"
      |where { |it| $it !~ $keep }
    )

    if $paths_remote == [] {
      sleep 37min
      continue
    }
    
    let paths_local = (^find $gcpath -type l
      |lines
      |par-each {|it| readlink -f $it|path split|last }
      |uniq
      |str replace "^(.{0,32})-(.+)\n" "$2-$1.gcinfo.gz"
    )
    
    let paths_deleted = ($paths_remote ++ $paths_local
      |uniq -u
      |sort
      |where { |it| $it in $paths_remote }
    )
    print $"Diff between remote and local is: ($paths_deleted|length)"

    if $paths_deleted == [] {
      sleep 37min
      continue
    }

    print $"Moving to ($remote_gc_trash)"
    print $paths_deleted
    ($paths_deleted
      |par-each {|it| $"mv '($remote_gc_roots)($it)' '($remote_gc_trash)($it)'" }
      |str join "\n"
      |s5cmd
        --credentials-file $creds
        --endpoint-url     $endpoint
        --profile          $profile
        run
    )

    sleep 37min
  }
}
