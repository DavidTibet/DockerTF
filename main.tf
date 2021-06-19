provider "aws" {
  region = "us-east-2"
}

variable "server_port" {
  description = "Port that server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "ssh_port" {
  description = " The port the server will use for SSH access"
  type        = number
  default     = 22
}

resource "aws_instance" "example" {
  ami                    = "ami-00399ec92321828f5"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name               = "vds-for-learning"
  depends_on             = [aws_security_group.instance]

  user_data = <<-EOF
	      #!/bin/bash
        curl https://get.docker.com | bash
	      EOF
}

resource "aws_security_group" "instance" {

  name = "terraform-example-instance1"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

