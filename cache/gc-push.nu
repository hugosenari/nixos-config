# GC uploader
def main [
 --bucket:   string = "nixstore",
 --creds:    string = "/ect/aws/credentials",
 --endpoint: string = "https://q4n8.or.idrivee2-24.com",
 --profile:  string = "nixstore",
 --filter:   string = "(nixos-rebuild)",
 --gcpath:   string = "/nix/var/nix/gcroots"
] {
  watch $gcpath --recursive true {|op, change_path, new_path|
    let hostname = (sys|get host.hostname)
    let real_path = (readlink -f $change_path)
    let gc_file = ($real_path
      |path basename
      |str replace "(^.{0,32})-(.+)$" "$2-$1.gcinfo"
    )

    print $"($op) ($real_path) ($gc_file) ($change_path)"
    if (
      $gc_file !~ "^ *$"   and $real_path !~ $filter  and 
      ($op     == "Create" or  $op        == "Chmod")
    ) {
      print "Collect GC Info"
      (nix path-info --recursive $real_path
        |awk '{sub(/-.+$/, ".narinfo"); sub(/^.+\//, ""); print $0}'
        |save -f --raw $"/tmp/($gc_file)"
      )
      gzip $"/tmp/($gc_file)"

      print $"Push /tmp/($gc_file).gz to s3://($bucket)/gcroots/($hostname)/($gc_file).gz"
      (s5cmd
        --credentials-file $creds
        --endpoint-url     $endpoint
        --profile          $profile
        cp
          $"/tmp/($gc_file).gz"
          $"s3://($bucket)/gcroots/($hostname)/($gc_file).gz"
      )

      rm $"/tmp/($gc_file).gz"
      echo "Done"
    }
  } 
}
