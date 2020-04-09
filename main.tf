terraform {
  required_version = ">= 0.12"
}

provider "aws" {
    region = "us-east-2"
}

## EC2 instnace ###

resource "aws_instance" "instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
#   vpc_security_group_ids = [aws_security_group.terraform-example-sg.id]
  security_groups = [aws_security_group.terraform-example-sg.name]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, Web server from Somenath" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  tags = {
      Name = "tf-server-02"
  }
}

## Security group for the EC2 instance to allow traffic on port 8080

resource "aws_security_group" "terraform-example-sg" {
  name = "terraform-example-sg"
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## Output 

output "public_ip" {
  value       = aws_instance.instance.public_ip
  description = "The public IP of the web server"
}

output "instance_state" {
  value       = aws_instance.instance.instance_state
  description = "State of the instance"
}
  