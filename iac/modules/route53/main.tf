terraform {
  backend "s3" {}
}

resource "aws_route53_record" "s3_website" {
  zone_id = var.website_zone_id
  name    = var.custom_domain
  type    = "A"

  alias {
    name                   = var.website_endpoint
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = true
  }
}

output "record_name" {
  description = "The Route 53 record name"
  value       = aws_route53_record.s3_website.name
}

