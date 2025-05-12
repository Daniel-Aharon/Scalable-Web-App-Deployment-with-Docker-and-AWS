provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "daniel-test-bucket-2025"
  force_destroy = true
}

resource "aws_s3_object" "my_file" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "uploaded-folder/test-pic.txt"
  source = "${path.module}/../test-pic.txt"
  etag   = filemd5("${path.module}/../test-pic.txt")
}

# Fetch the default VPC for the region
data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "flask_sg" {
  name        = "flask-sg"
  description = "Allow SSH, Flask port, and HTTP traffic"
  vpc_id      = data.aws_vpc.default.id  

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  ingress {
    description = "Flask App"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    description = "HTTP"
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

  tags = {
    Name = "FlaskAppSecurityGroup"
  }
}


resource "aws_instance" "app_server" {
  ami           = "ami-0f88e80871fd81e91"  # Updated with the new AMI ID for us-east-1
  instance_type = "t2.micro"
  key_name      = "DevOps6"  
  
  vpc_security_group_ids = [aws_security_group.flask_sg.id]  
  
  user_data = <<-EOF
              #!/bin/bash
              sudo dnf update -y
              sudo dnf install docker -y
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo docker pull danielaharon555/dock_deploy:main 
              sudo docker run -d -p 80:5000 danielaharon555/dock_deploy:main
            EOF

  tags = {
    Name = "FlaskAppServer"
  }
}