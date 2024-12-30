terraform {
  source = "../../../modules/s3"
}

inputs = {
  bucket_name = "newtimmy6.serverlessmy.id"
  region      = "ap-southeast-1"
  tags = {
    Environment = "production"
    Project     = "static-website"
  }
}

include {
  path = find_in_parent_folders()
}
