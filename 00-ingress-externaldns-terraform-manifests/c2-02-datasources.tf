# DataSources

# AWS RDS
data "aws_db_instance" "database1" {
  db_instance_identifier = "database-1"
}

output "aws_db_instance_address" {
  value = data.aws_db_instance.database1.address
}

output "aws_db_port" {
  value = data.aws_db_instance.database1.port
}

# Get DNS information from AWS Route53
data "aws_route53_zone" "mydomain" {
  name         = "seseri.co"
}

# Output
output "mydomain_name" {
  description = "The Hosted Zone name of the desired Hosted Zone"
  value = data.aws_route53_zone.mydomain.name
}

# GET existing ACM Cert
data "aws_acm_certificate" "issued" {
  domain   = data.aws_route53_zone.mydomain.name
  statuses = ["ISSUED"]
}