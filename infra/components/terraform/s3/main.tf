# Localstack bucket url:
# http://<bucket_name>.s3-website.localhost.localstack.cloud:4566/
# http://<bucket_name>.s3.localhost.localstack.cloud:4566/<key>

module "s3_bucket" {
  source  = "cloudposse/s3-bucket/aws"
  version = "4.7.1"

  name  = var.bucket_name
  stage = var.stage

  s3_object_ownership     = "BucketOwnerPreferred"
  enabled                 = true
  versioning_enabled      = true
  force_destroy           = true
  block_public_policy     = false
  restrict_public_buckets = false

  website_configuration = [
    {
      index_document = var.index_document
      error_document = var.error_document
      routing_rules  = []
    }
  ]
  source_policy_documents = [
    jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect    = "Allow"
          Principal = "*"
          Action    = "s3:GetObject"
          Resource  = "arn:aws:s3:::${var.stage}-${var.bucket_name}/*"
        }
      ]
    })
  ]
}
resource "aws_s3_object" "object_www" {
  depends_on   = [module.s3_bucket]
  bucket       = module.s3_bucket.bucket_id
  key          = var.index_document
  source       = "./${var.index_document}"
  content_type = "text/html"
  acl          = "private"
}
