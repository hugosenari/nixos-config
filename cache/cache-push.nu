# Cache uploader
def main [
 --bucket:   string = "nixstore",
 --creds:    string = "credentials",
 --endpoint: string = "https://q4n8.or.idrivee2-24.com",
 --profile:  string = "nixstore",
 --sig:      string = "/etc/nix/nixstore-key",
 --gcpath:   string = "/nix/var/nix/gcroots"
] {
  print $"Caching ($gcpath)"
  watch $gcpath --recursive true --debounce-ms 5 {|op, change_path, new_path|
    let hostname = (sys|get host.hostname)
    print $"($op) ($change_path) ($new_path)"
    if $op == "Create" or $op == "Chmod" {
      print "Resolving links"
      let $path = (readlink -f $change_path|{
        path: $in,
        refs: (nix path-info --recursive $change_path|lines)
      })
      
      print $"Sign ($path.path)"
      $path.refs|each {|pkg|
        nix store sign --key-file $sig $pkg 
      }

      let tmp_store = (mktemp -d)
      print $"Copy ($path.path) to ($tmp_store)"
      mkdir $"($tmp_store)/gcroots/($hostname)"
      nix copy --to $"file:///($tmp_store)?compression=zstd" $path.path

      let gc_file = ($path.path|path split|last|str replace "(^.{0,32})-(.+)$" "$2-$1")
 
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
