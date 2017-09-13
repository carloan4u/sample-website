terraform {
  backend "s3" {
    bucket = "zuto-terraform-state-files"
    key    = "services/dansmith-sample-app-aws/qa.tfstate"
    region = "eu-west-2"
    acl    = "bucket-owner-full-control"
  }
}

variable "environment" {
  default = "qa"
}

provider "aws" {
  region = "eu-west-2"
}

data "aws_caller_identity" "current" {}

resource "aws_elastic_beanstalk_application" "default" {
  name        = "dansmith-sample-app-aws"
  description = "Sample app for AWS by Dan Smith"
}

module "beanstalk-web-app" {
  source            = "git@github.com:carloan4u/terraform-aws-beanstalk-environment-module.git?ref=v1.2.7"
  app_name          = "${aws_elastic_beanstalk_application.default.name}"
  instance_type     = "t2.small"
  app_environment   = "${var.environment}"
  asg_min_instances = 1
  asg_max_instances = 2
  ec2_key           = "qa-ec2-applications"
  create_dns_record = true
  owner_tag         = "Sales-Ops"
  healthcheck_url = "/api/Status"

  sns_topic = {
    name = "${aws_elastic_beanstalk_application.default.name}-${var.environment}"
    endpoint = "arn:aws:sqs:eu-west-2:${data.aws_caller_identity.current.account_id}:${aws_elastic_beanstalk_application.default.name}-${var.environment}"
    protocol = "sqs"
  }
}

resource "aws_cloudwatch_metric_alarm" "dan-test-alarm" {
  count = "${length(module.beanstalk-web-app.instances)}"
  alarm_name                = "dan-test-alarm${count.index + 1}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "NetworkIn"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "55000"
  alarm_description         = "This metric monitors ec2 network in utilization"

  dimensions {
    InstanceId = "${element(module.beanstalk-web-app.instances, count.index)}"
  }
  alarm_actions     = ["arn:aws:sns:eu-west-2:276973094769:dansmith-sample-app-aws-Alerts"]
}
