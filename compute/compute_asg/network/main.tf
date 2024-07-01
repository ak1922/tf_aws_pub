# VPC for suto scaling group
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns

  tags = merge({ Name = "${local.aux_args.vnet_name}" }, local.module_tags)
}

# Internet gateway.
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc.id
}

# Public subnets for vpc
resource "aws_subnet" "subnet" {
  count = length(var.subnet_cidr)

  cidr_block        = var.subnet_cidr[count.index]
  availability_zone = var.av_zone[count.index]
  vpc_id            = aws_vpc.vpc.id

  tags = merge({ Name = "${local.aux_args.subnet_prefix}${count.index}" }, local.module_tags)
}

# Route table
resource "aws_route_table" "route_table" {
  route {
    cidr_block = var.gateway_cidr
    gateway_id = aws_internet_gateway.vpc_igw.id
  }

  vpc_id = aws_vpc.vpc.id

  tags = merge({ Name = "${local.aux_args.table_name}" }, local.module_tags)
}

# Route table associations
resource "aws_route_table_association" "table_assc" {
  count = "${length(var.subnet_cidr)}"

  subnet_id      = "${element(aws_subnet.subnet.*.id, count.index)}"
  route_table_id = aws_route_table.route_table.id
}

# ec2 security group
resource "aws_security_group" "sg1" {
  name   = local.aux_args.ec2sg_name
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.sg_rule
    content {
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = local.aux_args.ec2sg_name }, local.module_tags)
}

# Load balancer security group
resource "aws_security_group" "sg2" {
  name   = local.aux_args.elbsg_name
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    security_groups = [
      aws_security_group.sg1.id
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = local.aux_args.elbsg_name }, local.module_tags)
}
