terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}


resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/21"
}


resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/22"
  map_public_ip_on_launch = true


  tags = {
    Name = "subnet-pub"
  }
}


resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/22"


  tags = {
    Name = "subnet-priv"
  }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id


  tags = {
    Name = "internet-gateway"
  }
}


resource "aws_eip" "natIp" {
  domain = "vpc"


}


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.natIp.id
  subnet_id     = aws_subnet.public.id


  tags = {
    Name = "nat-public"
  }
  depends_on = [aws_internet_gateway.gw]
}




resource "aws_route_table" "public-table" {
  vpc_id = aws_vpc.main.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }


  tags = {
    Name = "route-table-public"
  }
}


resource "aws_route_table" "private-table" {
  vpc_id = aws_vpc.main.id


  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }


  tags = {
    Name = "route-table-private"
  }
}


resource "aws_route_table_association" "public-association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public-table.id
}


resource "aws_route_table_association" "private-association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private-table.id
}




resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH"
  vpc_id      = aws_vpc.main.id


  ingress {
    from_port   = 22
    to_port     = 22
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




resource "aws_instance" "public" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  key_name = "demo-1"


  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true


  tags = {
    Name = "public-instance"
  }
}


resource "aws_instance" "private" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  key_name = "demo-1"


  subnet_id = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = false


  tags = {
    Name = "private-instance"
  }
}
