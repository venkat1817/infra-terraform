#output.tf

output "dev-vpc" {
  value = aws_vpc.dev.id
}
