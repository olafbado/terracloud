provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
  profile = var.profile
}

data "aws_acm_certificate" "acm" {
  domain   = var.domain_name
  provider = aws.us_east_1
}

module "cdn" {
  source  = "cloudposse/cloudfront-s3-cdn/aws"
  version = "0.95.1"

  stage               = var.stage
  name                = var.bucket_name
  parent_zone_name    = var.zone_name
  aliases             = ["${var.domain_name}", "www.${var.domain_name}"]
  acm_certificate_arn = data.aws_acm_certificate.acm.arn
  index_document      = var.index_document
  error_document      = var.error_document

  origin_force_destroy        = true
  dns_alias_enabled           = true
  website_enabled             = true
  s3_website_password_enabled = true
  allow_ssl_requests_only     = "false"
}
