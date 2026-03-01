output "vpc_ids" {
  description = "vpc id"
  value       = aws_vpc.main.id
}

output "ec2_sg" {
  description = "ec2 standard sg"
  value       = aws_security_group.standard_sg.id
}

output "public_subnet_ids" {
  value = [for i in aws_subnet.main_public_subnet : i.id]
}

output "private_subnet_ids" {
  value = [for i in aws_subnet.main_private_subnet : i.id]
}

output "alb_sg_ids" {
  value = aws_security_group.lb_sg.id
}
