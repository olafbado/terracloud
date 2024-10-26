module "acm_request_certificate" {
  source                    = "cloudposse/acm-request-certificate/aws"
  version                   = "0.18.0"
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
}
