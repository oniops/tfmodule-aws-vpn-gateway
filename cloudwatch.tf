locals {
  cloudwatch_log_group_name = var.cloudwatch_log_group_name != null ? var.cloudwatch_log_group_name : "/aws/vpn${local.cgw_connection_name}"
}

resource "aws_cloudwatch_log_group" "this" {
  count             = local.create_cgw  && local.enable_cloudwatch_log_group ? 1 : 0
  name              = local.cloudwatch_log_group_name
  retention_in_days = var.retention_in_days
  lifecycle {
    create_before_destroy = true
  }
}

