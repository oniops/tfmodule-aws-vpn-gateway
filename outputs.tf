output "cgw_id" {
  description = "The ID of Customer Gateway"
  value       = try(aws_customer_gateway.this[0].id, "")
}

output "cgw_arn" {
  description = "The ARN of Customer Gateway"
  value       = try(aws_customer_gateway.this[0].arn, "")
}
