# Localstack api URL:
# http://<api_id>.execute-api.<region>.localhost.localstack.cloud:4566/<stage>/
# http://qr93otiqjo..execute-api.eu-central-1.localhost.localstack.cloud:4566/dev/

module "api_gateway" {
  source  = "cloudposse/api-gateway/aws"
  version = "0.7.1"

  name       = var.name
  stage_name = var.stage_name
  enabled    = true

  openapi_config = {
    openapi = "3.0.1"
    info = {
      title   = "example"
      version = "1.0"
    }
    paths = {
      "/abc" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "POST"
            payloadFormatVersion = "2.0"
            type                 = "AWS_PROXY"
            uri                  = "arn:aws:apigateway:eu-central-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-central-1:000000000000:function:hello-world/invocations"
          }
        }
      }
    }
  }
}
