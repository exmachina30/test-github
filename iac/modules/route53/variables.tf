variable "custom_domain" {
  description = "The custom domain to point to the S3 website"
  type        = string
}

variable "website_endpoint" {
  description = "The S3 website endpoint"
  type        = string
}

variable "website_zone_id" {
  description = "The S3 website zone ID"
  type        = string
}