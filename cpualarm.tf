module "sns" {
  source  = "terraform-aws-modules/sns/aws"
  version = "3.3.0"
  name    = format("%s-cw-alarm", "sns-topic")
}

resource "aws_cloudwatch_metric_alarm" "foobar" {
  alarm_name                = "terraform-test-foobar5"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions             = [module.sns.sns_topic_arn]
  insufficient_data_actions = []
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = module.sns.sns_topic_arn
  protocol  = "email"
  endpoint  = var.email
}