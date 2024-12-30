terraform {
  source = "../../../modules/route53"
}

dependency "cloudfront" {
  config_path = "../cloudfront"
}

dependency "s3" {
  config_path = "../s3"
}

inputs = {
  custom_domain    = "newtimmy6.serverlessmy.id"
  website_endpoint = dependency.cloudfront.outputs.cloudfront_domain_name
  website_zone_id  = "<hosted_zone_id>"
}

include {
  path = find_in_parent_folders()
}
