# Configure the minimal Terraform version
terraform {
  required_version = ">= 1.1.7"
}

# Configure the AWS Provider
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "random_string" "random" {
  length = 6
  numeric = false
  upper = false
  special = false
}

locals {
  prefix = "hoodie-demo-${length(var.prefix)>0 ? var.prefix : random_string.random.result}"
}

resource "aws_key_pair" "ubuntu" {
  key_name   = "${local.prefix}ssh-key"
  public_key = file("key.pub")

  tags = {
    Name = "${local.prefix}/ssh-key"
  }
}

resource "aws_security_group" "cluster-security-group" {
  name        = "${local.prefix}/cluster-security-group"
  description = "Allow HTTP, HTTPS and SSH traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = data.aws_vpc.vpc.id

  # Spark UI - TODO figure out how to expose this, terraform refuses to create the cluster with this rule here, but accepts to modify the dpeloyment and add it later :|
 /* ingress {
    description = "HTTP"
    from_port   = 18080
    to_port     = 18080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }*/

  egress {
    description       = "Allow all egress traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks  = ["::/0"]
  }

  tags = {
    Name = "${local.prefix}/cluster-security-group-sg"
    keep = "true"
  }
}

resource "aws_security_group" "app-security-group" {
  name        = "${local.prefix}/app-security-group"
  description = "Allow HTTP, HTTPS and SSH traffic"

  vpc_id = data.aws_vpc.vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # database
  ingress {
    description = "HTTP"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # backend
  ingress {
    description = "HTTP"
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # frontend
  ingress {
    description = "HTTP"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.prefix}/app-security-group-sg"
    keep = "true"
  }
}
