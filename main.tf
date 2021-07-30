terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = var.aws_profile
  region  = "us-west-2"
  default_tags {
    tags = {
      Terraform = "true"
      Git = "mederrata.terraform-cloudfront-bucket"
    }
  }
}

resource "aws_s3_bucket" "cloudfront_bucket" {
  bucket = var.cloudfront_bucket
  acl = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.sse_algorithm
      }
    }
  }
  tags = {
    Name = "public-cdn-bucket"
  }
}


resource "aws_s3_bucket" "cloudfront_log_bucket" {
  bucket = var.cloudfront_log_bucket
  acl = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.sse_algorithm
      }
    }
  }
  tags = {
    Name = "public-cdn-bucket"
  }
}

resource "aws_cloudfront_origin_access_identity" "s3_origin_identity" {
  comment = "cdn_bucket"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.cloudfront_bucket.bucket_regional_domain_name
    origin_id   = var.cloudfront_bucket

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.s3_origin_identity.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Share CDN Files"

  logging_config {
    include_cookies = false
    bucket          = "${aws_s3_bucket.cloudfront_log_bucket.bucket_domain_name}"
    prefix          = ""
  }

  aliases = ["${var.domain_name}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.cloudfront_bucket

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = var.cloudfront_bucket

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA"]
    }
  }

  tags = {
    Environment = "production"
    Name = "public-cdn"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
