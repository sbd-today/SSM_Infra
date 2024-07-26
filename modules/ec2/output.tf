
output "ec2_instance_sg_id" {
  description = "SG ID"
  value       = try(aws_security_group.ec2_instance_sg.id, null)
}


output "instance_id" {
  value = try(aws_instance.ec2-web.id)
}

output "ec2_alb" {
  value = (var.require_alb == true ? try(aws_lb.elb[0].dns_name) : null)
}