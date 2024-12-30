terraform {
  source = "../../../modules/cloudfront"
}

dependency "s3" {
  config_path = "../s3"
}

inputs = {
  bucket_name            = dependency.s3.outputs.bucket_name
  website_endpoint       = dependency.s3.outputs.regional_domain_name
  acm_certificate_arn    = "arn:aws:acm:us-east-1:166190020492:certificate/1119d63b-db83-4afb-b726-4a8944f6ec7f"
  tags = {
    Environment = "production"
    Project     = "static-website"
  }
}

include {
  path = find_in_parent_folders()
}
