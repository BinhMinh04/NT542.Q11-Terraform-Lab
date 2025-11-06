######################################
# Outputs for EC2 Instance
######################################

output "instance_id" {
  description = "The ID of the EC2 instance."
  value       = aws_instance.main.id
}

output "instance_arn" {
  description = "The ARN of the EC2 instance."
  value       = aws_instance.main.arn
}
######################################
# Outputs for EBS Volumes
######################################

output "ebs_volume_ids" {
  description = "The list of IDs of the EBS volumes attached to the instance."
  value       = [for v in aws_ebs_volume.dependence : v.id]
}
