variable "allowed_ips" {
  type        = list(string)
  description = "A list of one or more ip addresses (not cidr's) that you will be accessing from."
  default     = ["73.78.216.54"]
}

resource "aws_vpc" "k8s" {
  cidr_block           = "10.240.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "k8s" {
  vpc_id = aws_vpc.k8s.id

  tags = {
    Name = "k8s"
  }
}

resource "aws_subnet" "k8s" {
  vpc_id            = aws_vpc.k8s.id
  cidr_block        = aws_vpc.k8s.cidr_block
  availability_zone = "us-west-2b"

  tags = {
    Name = "k8s"
  }
}

resource "aws_security_group" "k8s" {
  name        = "k8s"
  description = "Single security group for all K8s The Hard Way needs - for now..."

  vpc_id = aws_vpc.k8s.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      for ip in var.allowed_ips :
      "${ip}/32"
    ]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_subnet.k8s.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "k8s_external" {
  vpc = true
}
