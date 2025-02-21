
# VPC for the web app instances
resource "aws_vpc" "app-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.app-name}-vpc"
  }
}

# subnets for the web app instances
resource "aws_subnet" "app-subnets" {
  count      = var.num-replicas
  vpc_id     = aws_vpc.app-vpc.id
  cidr_block = "10.0.${count.index + 1}.0/24"
  availability_zone_id = element(data.aws_availability_zones.available.names, count.index)
}

data "aws_availability_zones" "available" {
  state = "available"
}

# SG used with instances to allow inbound traffic
resource "aws_security_group" "instances" {
  name   = "instance-security-group"
  vpc_id = aws_vpc.app-vpc.id
}

# security group rule to allow ingress traffic on port 8080
resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.instances.id
  from_port = 8080
  to_port   = 8080
  protocol  = "tcp"
  #allowing all ip addressess
  cidr_blocks = ["0.0.0.0/0"]
}
