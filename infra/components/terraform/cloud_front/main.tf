data "aws_region" "current" {}

provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
  profile = var.profile
}

resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"
  provider                  = aws.us_east_1
}

module "cdn" {
  source  = "cloudposse/cloudfront-cdn/aws"
  version = "1.2.0"

  stage                  = var.stage
  name                   = var.name
  aliases                = ["${var.domain_name}", "www.${var.domain_name}"]
  parent_zone_name       = var.zone_name
  origin_domain_name     = "${var.stage}-${var.bucket_name}.s3-website.${data.aws_region.current.name}.amazonaws.com"
  origin_protocol_policy = "http-only"

  acm_certificate_arn = aws_acm_certificate.cert.arn

  log_force_destroy = true
  logging_enabled   = true

  default_root_object = var.index_document
}
