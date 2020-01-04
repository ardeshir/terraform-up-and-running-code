terraform {
  required_version = ">= 0.12, < 0.13" 
}

provider "aws" {
  region = "us-east-1"

  # Allow any 2.x version of the AWS provider
  version = "~> 2.0"
}

resource "aws_instance" "example" {
  ami           = "ami-04b9e92b5572fa0d1"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Terraform busybox" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  tags = {
      Name = "terraform-ec2-ubuntu"
  }

}

resource "aws_security_group" "instance" {
    name = "tf-instance"

    ingress {
     from_port   = 8080
     to_port     = 8080
     porotocol   = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
    }
}
