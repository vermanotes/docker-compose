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

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "2.6.0"
  name = "sushiver-vpc-aws-eks"
  cidr = "10.0.0.0/16" # 192.168, 172.16
  azs = data.aws_availability_zone.available.names
  public_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_dns_support = true # required for enabling the Ingress
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/sushiver-aws-eks" = "shared"
  }
}
module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "7.0.0"

  # insert the 4 required variables here
  cluster_name = "sushiver-aws-eks"
  subnet = module.vpc.public_subnets
  vpc_id = module.vpc.vpc_id

  # worker nodes
  worker_group_launch_template = [
    
  ]
}
