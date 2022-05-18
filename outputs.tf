output "subnetids" {
  value = data.aws_subnets.all.ids
}

output "name" {
  value = aws_security_group.ecs.id
}