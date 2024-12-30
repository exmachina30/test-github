variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "tags" {
  description = "Tags to assign to the resources"
  type        = map(string)
  default     = {
    Environment = "production"
    Project     = "static-website"
  }
}
