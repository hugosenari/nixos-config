# Cache uploader
def main [
 --bucket:   string = "nixstore",
 --creds:    string = "credentials",
 --endpoint: string = "https://q4n8.or.idrivee2-24.com",
 --profile:  string = "nixstore",
 --sig:      string = "/etc/nix/nixstore-key",
 --filter:   string = "(nixos-rebuild)",
 --gcpath:   string = "/nix/var/nix/gcroots"
] {
  print $"Caching ($gcpath)"
  watch $gcpath --recursive true --debounce-ms 5 {|op, change_path, new_path|
    let hostname = (sys|get host.hostname)
    let real_path = (readlink -f $change_path)
    print $"($op) ($change_path) ($new_path) ($real_path)"
    if $op == "Create" or $op == "Chmod" and $real_path != "" and $real_path !~ $filter {
      print "Resolving links"
      let $path = {
        path: $real_path,
        refs: (nix path-info --recursive $real_path|lines)
      }
      
      print $"Sign ($path.path) and deps"
      $path.refs|par-each {|pkg|
        nix store sign --key-file $sig $pkg 
      }

      let gc_file = ($path.path|path split|last|str replace "(^.{0,32})-(.+)$" "$2-$1")

      let tmp_store = $"/tmp/($gc_file)"
      print $"Copy ($path.path) to ($tmp_store)"
      mkdir $"($tmp_store)/gcroots/($hostname)"
      nix copy --to $"file:///($tmp_store)?compression=zstd" $path.path

 
      print "Comp GC info"
      (grep   -o -EH 'nar/.+$' $"($tmp_store)/*.narinfo"
        |grep -o -E  '.{32}.narinfo:nar/.+.nar.*$'
        |lines
        |save --raw $"($tmp_store)/gcroots/($hostname)/($gc_file).gcinfo")
      gzip  $"($tmp_store)/gcroots/($hostname)/($gc_file).gcinfo"

      # Makes sure we have GCInfo uploaded first 
      print $"Push ($tmp_store)/gcroots to s3://($bucket)/gcroots"
      (s5cmd
        --credentials-file $creds
        --endpoint-url     $endpoint
        --profile          $profile
        cp
          --no-clobber
          $"($tmp_store)/gcroots/"
          $"s3://($bucket)/gcroots/"
      )

      print $"Push ($tmp_store) to s3://($bucket)/"
      (s5cmd
        --credentials-file $creds
        --endpoint-url     $endpoint
        --profile          $profile
        cp
          --no-clobber
          --exclude "*.gz"
          $"($tmp_store)/"
          $"s3://($bucket)/"
      )
      
      rm --recursive $tmp_store
      echo "Done"
    }
  } 
}
