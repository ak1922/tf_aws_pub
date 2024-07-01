output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_arn" {
  value = aws_vpc.vpc.arn
}

output "subnet_ids" {
  value = ["${aws_subnet.subnet.*.id}"]
}
