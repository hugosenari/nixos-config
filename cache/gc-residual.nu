# Cache purge
# Remove all files that has no reference in gcroot
# WARNING: it should be a slow operation

def main [
 --bucket:   string = "nixstore",
 --creds:    string = "credentials",
 --endpoint: string = "https://q4n8.or.idrivee2-24.com",
 --profile:  string = "nixstore",
 --cachepath:string = "/tmp/nixgc.cache/"
] {
  let remote_cache    = $"s3://($bucket)/"
  let remote_gc_roots = $"s3://($bucket)/gcroots/"
  let local__gc_roots = $"($cachepath)gcroots/"
  mkdir $"($cachepath)gcroots"
  print $"Remote cache ($remote_cache)"
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

  print $"Listing all narinfo"
  let narinfos = (s5cmd
    --credentials-file $creds
    --endpoint-url     $endpoint
    --profile          $profile
    ls $"s3://($bucket)/*.narinfo"
    |awk '{print $NF}'
    |lines
  )

  let unkowns_info = ($narinfos
    |where {|it| ($gcroots|get -i $it) != true}
  )

  if $unkowns_info == [] {
    print "No dereferenced narinfo"
    exit 0
  }

  print $"Fetch dereferenced narinfo"
  let unkowns_nar = ($unkowns_info
    |par-each {|it| $"cat ($remote_cache)($it)"}
    |str join "\n"
    |s5cmd
      --credentials-file $creds
      --endpoint-url     $endpoint
      --profile          $profile
      run
    |awk '/^URL:/ {print $NF};'
    |lines
  )

  let delete_unknows_info = ($unkowns_info
    |par-each {|it| $"rm ($remote_cache)($it)"}
    |str join "\n"
  )

  let delete_unknows_nar = ($unkowns_nar
    |par-each {|it| $"rm ($remote_cache)($it)"}
    |str join "\n"
  )
  
  print "Deleting"
  let delete = $delete_unknows_nar + "\n" + $delete_unknows_info
  print $delete
  
  ($delete
    |s5cmd
      --credentials-file $creds
      --endpoint-url     $endpoint
      --profile          $profile
      run
  )
}
