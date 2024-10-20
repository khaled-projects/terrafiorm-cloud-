provider "aws" {
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}






# Create an EC2 instance without key pair and security group rules
resource "aws_instance" "example_instance" {
  ami           = "ami-0ddc798b3f1a5117e"  # Replace with a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = subnet-05f6b3cd6a8e39128
  security_groups = sg-030e0f2c0e7336c77

  associate_public_ip_address = true  # Instance will have a public IP

  tags = {
    Name = "SentinelTestInstance"
  }
}

# Output the instance public IP
output "instance_public_ip" {
  value = aws_instance.example_instance.public_ip
}
