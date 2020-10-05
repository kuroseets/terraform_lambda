variable access_key {}
variable secret_key {}

terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "kuroseets"

    workspaces {
      name = "terraform-lambda"
    }
  }
}
provider aws {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "ap-northeast-1"
}

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"
  function_name = "my-lambda1"
  description   = "My awssome lambda function"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  source_path = "./src/lambda_function.py"
  environment_variables = {
    SLACK_WEBHOOK_URL = "https://hooks.slack.com/services/TXXXXXXXX/BXXXXXXXX/XXXXXXXXXXXXXXXXXXXXXXXX"
    CHANNEL_NAME      = "#amazon_test"
  }
  tags = {
    Name = "my-lambda1"
  }
}
resource "aws_cloudwatch_event_rule" "lambda-test-terrform" {
    name                = "lambda-test-terrform"
    schedule_expression = "cron(*/5 * * * ? *)"
}
resource "aws_cloudwatch_event_target" "lambda-test-terrform" {
    rule      = aws_cloudwatch_event_rule.lambda-test-terrform.name
    target_id = "output_report"
    arn       = module.lambda_function.this_lambda_function_arn
}
resource "aws_lambda_permission" "allow_cloudwatch_to_call_output_report" {
    statement_id  = "AllowExecutionFromCloudWatch"
    action        = "lambda:InvokeFunction"
    function_name =  module.lambda_function.this_lambda_function_name
    principal     = "events.amazonaws.com"
    source_arn    = aws_cloudwatch_event_rule.lambda-test-terrform.arn
}
