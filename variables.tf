variable "aws_profile" {
  type = string
  default = "default"
  description = "Choose AWS profile credentials"
}

variable "cloudfront_origin_id" {
  type = string
  default = "cloudfront_origin_id"
  description = "Registered origin ID in cloudfront"
}

variable "cloudfront_bucket" {
  type = string
  default = ""
  description = "Bucket used to host public objects"
}

variable "cloudfront_log_bucket" {
  type = string
  default = ""
  description = "Cloudfront will store logs in this bucket"
}

variable "cloudfront_log_bucket_prefix" {
  type = string
  default = ""
  description = "Cloudfront will store logs in this bucket prefix"
}

variable "domain_name" {
  type = string
  default = "example.com"
  description = "domain name for the cdn"
}

# https://aws.amazon.com/cloudfront/pricing/
variable "cloudfront_price_class" {
  type = string
  default = "PriceClass_100"
  description = "Passible values include: PriceClass_All, PriceClass_200, and PriceClass_100. Default: PriceClass_100"
}

variable "sse_algorithm" {
  type        = string
  default     = "AES256"
  description = "The server-side encryption algorithm to use. Valid values are `AES256` and `aws:kms`"
}

