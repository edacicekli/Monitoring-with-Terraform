terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "eu-central-1"
}

resource "aws_instance" "terraform" {
  ami                    = "ami-0d527b8c289b4af7f"
  instance_type          = "t2.micro"
  key_name               = "aws_key"
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.terraform_sg.id]

  tags = {
    Name = "Terraform Project"
  }

  provisioner "file" {
  source = "/home/eda/Kondukto/docker-compose.yml"
  destination = "/home/ubuntu/docker-compose.yml"    
  }

  provisioner "file" {
    source = "/home/eda/Kondukto/prometheus.yml"
    destination = "/home/ubuntu/prometheus.yml"    
  }

  provisioner "file" {
    source      = "/home/eda/Kondukto/data_"
    destination = "/home/ubuntu/"
  }

  provisioner "file" {
    source = "script.sh"
    destination = "/tmp/script.sh"
    
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
    ]    
  }

  provisioner "remote-exec" {
    inline = [
      "/bin/bash /tmp/script.sh",
    ]    
  }

  connection {
    type        = "ssh"
    port        = 22
    user        = "ubuntu"
    private_key = file("/home/eda/aws/aws_key")
    host        = self.public_ip
    timeout     = "4m"
    agent       = false
  }
}

module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "2.64.0"
  name            = "mainvpc"
  cidr            = "10.88.0.0/16"
  public_subnets  = ["10.88.1.0/24"]
  private_subnets = ["10.88.101.0/24"]
  azs             = ["eu-central-1a"]
}

resource "aws_security_group" "terraform_sg" {
  vpc_id = module.vpc.vpc_id
  name   = "terraform-sg"

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

  ingress {
    from_port   = 443
    to_port     = 443
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

resource "aws_key_pair" "deployer" {
  key_name   = "aws_key"
  public_key = "public_key"
}