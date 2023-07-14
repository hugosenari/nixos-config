# GC uploader
def main [
 --bucket:   string = "nixstore",
 --creds:    string = "/ect/aws/credentials",
 --endpoint: string = "https://q4n8.or.idrivee2-24.com",
 --profile:  string = "nixstore",
 --filter:   string = "(nixos-rebuild)",
 --gcpath:   string = "/nix/var/nix/gcroots"
] {
  watch $gcpath --recursive true --debounce-ms 5 {|op, change_path, new_path|
    let hostname = (sys|get host.hostname)
    let real_path = (readlink -f $change_path)
    print $"($op) ($real_path) ($change_path) ($new_path)"
    if $op == "Create" or $op == "Chmod" and $real_path != "" and $real_path !~ $filter {
      let gc_file = ($real_path
        |path basename
        |str replace "(^.{0,32})-(.+)$" "$2-$1.gcinfo"
      )

      print "Collect GC Info"
      (nix path-info --recursive $real_path
        |awk '{sub(/-.+$/, ".narinfo"); sub(/^.+\\//, ""); print $1}'
        |save --raw $"/tmp/($gc_file)"
      )
      gzip $"/tmp/($gc_file)"

      print $"Push /tmp/($gc_file).gz to s3://($bucket)/gcroots/($hostname)/($gc_file).gz"
      (s5cmd
        --credentials-file $creds
        --endpoint-url     $endpoint
        --profile          $profile
        cp
          --no-clobber
          $"/tmp/($gc_file).gz"
          $"s3://($bucket)/gcroots/($hostname)/($gc_file).gz"
      )

      rm $"/tmp/($gc_file)"
      echo "Done"
    }
  } 
}
