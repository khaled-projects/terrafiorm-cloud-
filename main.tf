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

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

# Create a subnet
resource "aws_subnet" "example_subnet" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
}

# Create an internet gateway to allow public traffic
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example.id
}

# Create a route table
resource "aws_route_table" "example_route_table" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "example_association" {
  subnet_id      = aws_subnet.example_subnet.id
  route_table_id = aws_route_table.example_route_table.id
}

# Create a security group without specific rules
resource "aws_security_group" "example_sg" {
  vpc_id = aws_vpc.example.id  # Associate it with the correct VPC
}

# Create an EC2 instance without key pair and security group rules
resource "aws_instance" "example_instance" {
  ami           = "ami-0ddc798b3f1a5117e"  # Replace with a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.example_subnet.id
  security_groups = [aws_security_group.example_sg.name]  # Reference the security group

  associate_public_ip_address = true  # Instance will have a public IP

  tags = {
    Name = "SentinelTestInstance"
  }
}

# Output the instance public IP
output "instance_public_ip" {
  value = aws_instance.example_instance.public_ip
}
