terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.region  
}

resource "aws_s3_bucket" "website" {
  bucket        = var.bucket_name
  force_destroy = true 

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.website.id
}

output "regional_domain_name" {
  description = "S3 regional domain name"
  value       = aws_s3_bucket.website.bucket_regional_domain_name
}

output "hosted_zone_id" {
  description = "S3 website hosted zone ID"
  value       = aws_s3_bucket.website.hosted_zone_id
}

