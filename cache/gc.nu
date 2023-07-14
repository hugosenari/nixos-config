# Cache purge
def main [
 --bucket:   string = "nixstore",
 --creds:    string = "credentials",
 --endpoint: string = "https://q4n8.or.idrivee2-24.com",
 --profile:  string = "nixstore",
 --cachepath:string = "/tmp/nixgc.cache/"
] {
  let remote_cache    = $"s3://($bucket)/"
  let remote_gc_roots = $"s3://($bucket)/gcroots/"
  let remote_gc_trash = $"s3://($bucket)/gctrash/"
  let local__gc_roots = $"($cachepath)gcroots/"
  let local__gc_trash = $"($cachepath)gctrash/"
  mkdir $"($cachepath)gcroots"
  mkdir $"($cachepath)gctrash"
  print $"Remote cache ($remote_cache)"
  loop {
    print $"Sync gcinfo from ($remote_cache)gctrash to ($local__gc_trash)"
    (s5cmd
      --credentials-file $creds
      --endpoint-url     $endpoint
      --profile          $profile
      sync 
      --size-only
      --delete
      $"($remote_gc_trash)*"
      $local__gc_trash
    )

    print $"Parsing GCTRASH"
    let gctrash = (do {zcat ($"($local__gc_trash)*gcinfo.gz"|path expand)}
      |complete | if $in.exit_code > 0 { "" } else { $in.stdout }
      |lines
      |uniq
    )

    if $gctrash == [] {
      print "No GCROOT moved to GCTRASH since last check"
      sleep 41min
      continue
    }

    print $"Sync gcinfo from ($remote_cache)/gcroots to ($local__gc_roots)"
    (s5cmd
      --credentials-file $creds
      --endpoint-url     $endpoint
      --profile          $profile
      sync 
      --size-only
      --delete
      $"($remote_gc_roots)*"
      $local__gc_roots
    )

    print $"Parsing GCROOTS"
    let gcroots = (do { zcat ($"($local__gc_roots)*/*gcinfo.gz"|path expand) }
      |complete | if $in.exit_code > 0 { "" } else { $in.stdout }
      |lines
      |uniq
      |reduce  --fold {} {|it, acc|
        $acc|insert $it true
      }
    )

    let paths_deleted = ($gctrash
      |where {|it| ($gcroots|get -i $it) != true}
    )


    let delete_gcinfo = (ls -s ($"($local__gc_trash)*gcinfo.gz"|path expand)
      |par-each {|it| $"rm ($remote_gc_trash)($it.name)"}
      |str join "\n"
    )

    let delete_narifo = ($paths_deleted
      |str replace ":" "\n"
      |str join        "\n"
      |lines
      |par-each {|it| $"rm ($remote_cache)($it)" }
      |str join        "\n"
    )

    print "Deleting"
    let delete = $delete_gcinfo + "\n" + $delete_narifo
    print $delete

    ($delete
      |s5cmd
        --credentials-file $creds
        --endpoint-url     $endpoint
        --profile          $profile
        run
    )

    sleep 41min
  }
}
