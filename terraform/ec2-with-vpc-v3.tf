provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0c7217cdde317cfec" # ubuntu 22
  instance_type = "t2.micro"
  key_name      = "devops_workshop"
  # security_groups = [ "demo-sg" ]
  vpc_security_group_ids = [ aws_security_group.demo-sg.id ]
  subnet_id = aws_subnet.devops-workshop-subnet1.id
  for_each = toset(["jenkins-controller", "jenkins-builder", "ansible-controller"])
}

# Networking

resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "Allow ssh"
  vpc_id = aws_vpc.devops-workshop-vpc.id
  
  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.demo-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.demo-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

##############
#    VPC     
##############
resource "aws_vpc" "devops-workshop-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    "Name" = "devops-workshop"
  }
}

resource "aws_subnet" "devops-workshop-subnet1" {
  vpc_id     = aws_vpc.devops-workshop-vpc.id
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "devops-workshop-public-subnet1"
  }
}

resource "aws_subnet" "devops-workshop-subnet2" {
  vpc_id     = aws_vpc.devops-workshop-vpc.id
  cidr_block = "10.1.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"

  tags = {
    Name = "devops-workshop-public-subnet2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.devops-workshop-vpc.id

  tags = {
    Name = "devops-workshop-vpc-igw"
  }
}

resource "aws_route_table" "devops-workshop-vpc-public-route-table" {
  vpc_id = aws_vpc.devops-workshop-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "devops-workshop-vpc-public-route-table"
  }
}

resource "aws_route_table_association" "devops-workshop-subnet1-association" {
  subnet_id      = aws_subnet.devops-workshop-subnet1.id
  route_table_id = aws_route_table.devops-workshop-vpc-public-route-table.id
}

resource "aws_route_table_association" "devops-workshop-subnet2-association" {
  subnet_id      = aws_subnet.devops-workshop-subnet2.id
  route_table_id = aws_route_table.devops-workshop-vpc-public-route-table.id
}