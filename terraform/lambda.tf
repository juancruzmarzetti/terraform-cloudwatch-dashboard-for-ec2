resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_lambda_permission" "allow_sns" {
  statement_id = "AllowExecutionFromSNS"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.slack_notification.function_name
  principal = "sns.amazonaws.com"
  source_arn = module.sns.sns_topic_arn
}

resource "aws_sns_topic_subscription" "lambda_subscription" {
  topic_arn = module.sns.sns_topic_arn
  protocol = "lambda"
  endpoint = aws_lambda_function.slack_notification.arn
}

resource "aws_iam_role_policy" "lambda_exec_policy" {
  name = "lambda_exec_policy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        Effect   = "Allow",
        Resource = "arn:aws:logs:*:*:*",
      },
      {
        Action = "sns:Publish",
        Effect = "Allow",
        Resource = module.sns.sns_topic_arn,
      }
    ],
  })
}

resource "aws_lambda_function" "slack_notification" {
  filename = "${path.module}/../lambda_function.zip"
  function_name = "slack_notification"
  role = aws_iam_role.lambda_exec_role.arn
  handler = "lambdafunction.lambda_handler"
  runtime = "python3.9"
  source_code_hash = filebase64sha256("${path.module}/../lambda_function.zip")

  environment {
    variables = {
      SLACK_WEBHOOK_URL = var.slack_url_webhook
    }
  }
}