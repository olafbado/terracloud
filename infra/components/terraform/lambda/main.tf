
module "aws_lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 2.0"

  function_name = "hello-world"
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  source_path = [
    "${path.module}/index.js"
  ]
}
