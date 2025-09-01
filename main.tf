# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = "us-east-2"
}

provider "random" {}

resource "random_pet" "name" {}

# Generate EC2 SSH Key Pair (local ephemeral key for demo)
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key" {
  key_name   = "test-demo-key"
  public_key = tls_private_key.example.public_key_openssh
}

# Generates a local file with name 'filename' with the contents of the EC2 Key Pair
# This can be used to SSH into the EC2 instanace which gets created
# This also gets deleted by Terraform when issuing 'terraform destroy' command
resource "local_file" "my-ec2-keypair" {
  content = tls_private_key.example.private_key_pem
  filename = "${aws_key_pair.key.key_name}.pem"
}

resource "aws_security_group" "web-sg" {
  name = "${random_pet.name.id}-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# EC2 Instance (Amazon Linux 2023)
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key.key_name
  user_data     = file("init-script.sh")
  vpc_security_group_ids = [aws_security_group.web-sg.id]

  tags = {
    Name = random_pet.name.id
  }
}
