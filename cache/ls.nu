# List remote gcroots

def main [
 --bucket:   string = "nixstore",
 --creds:    string = "credentials",
 --endpoint: string = "https://q4n8.or.idrivee2-24.com",
 --profile:  string = "nixstore",
] {
  $env.AWS_SHARED_CREDENTIALS_FILE = $creds
  (
    s5cmd 
      --credentials-file $creds
      --json 
      --profile $profile 
      --endpoint-url $endpoint
      ls $"s3://($bucket)/gcroots/*/*.gz"
    |lines
    |each {|it|
      $it
      |from json
      |get key
      |str replace $"s3://($bucket)/" ""
    }
    |par-each {|it| 
      (
        { key: ($it|str replace "gcroots/" "") }
        |merge (
           aws s3api head-object 
             --profile $profile
             --endpoint-url $endpoint
             --bucket $bucket 
             --key $it
           |from json
           |select -i Metadata.closuresize LastModified
           |{ closure: $in.Metadata_closuresize, created: ($in.LastModified|into datetime) })
      )
    }
    |sort-by key
  )
}
