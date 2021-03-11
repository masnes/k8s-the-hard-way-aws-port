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

resource "aws_route_table" "k8s" {
  vpc_id = aws_vpc.k8s.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s.id
  }
  tags = {
    Name = "K8s Basic VPC Route Table"
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

resource "aws_route_table_association" "k8s" {
  subnet_id      = aws_subnet.k8s.id
  route_table_id = aws_route_table.k8s.id
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

resource "aws_lb" "k8s" {
  name = "k8s-the-hard-way-load-balancer"
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id = aws_subnet.k8s.id
    allocation_id = aws_eip.k8s_external.id
  }

}

resource "aws_lb_target_group" "k8s_api_server" {
  name = "k8s-the-hard-way-lb-tgt-api-srv"
  port = 6443
  protocol = "TCP"
  vpc_id = aws_vpc.k8s.id

  health_check {
    port = 80
    path = "/healthz"
  }
}

resource "aws_lb_listener" "k8s" {
  load_balancer_arn = aws_lb.k8s.arn
  port = 6443

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.k8s_api_server.arn
  }
}

resource "aws_lb_target_group_attachment" "k8s-controllers" {
  count = length(aws_instance.controller)
  target_group_arn = aws_lb_target_group.k8s_api_server.arn
  target_id = aws_instance.controller[count.index].id
}
