terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.region  
}

resource "aws_cloudfront_distribution" "website" {
  origin {
    domain_name = var.website_endpoint
    origin_id   = var.website_endpoint

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id       = var.website_endpoint
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
    query_string = false

    cookies {
      forward = "none"
    }
   }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  aliases = var.alternate_domain_names

  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = "sni-only"
  }

  tags = var.tags
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for S3 bucket ${var.bucket_name}"
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = var.bucket_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.oai.iam_arn
        }
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::${var.bucket_name}/*"
      }
    ]
  })
}

output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.website.domain_name
}

