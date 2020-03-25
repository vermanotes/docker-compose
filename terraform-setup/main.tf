provider "aws" {
  region = "us-east-1"
  profile = "terraform-operator"
}

data = "aws_availability_zone" "available" {

}

output "AZs" {
  values = data.aws_availability_zone.available.names
  description = "list of AWS Availability Zones within the region"
}
