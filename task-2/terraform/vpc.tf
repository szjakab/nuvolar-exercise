resource "aws_vpc" "vpc" {
  cidr_block           = "172.33.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-${local.env}-vpc"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-${local.env}-igw"
  })
}

resource "aws_eip" "natgw" {

}

resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.natgw.id
  subnet_id     = aws_subnet.subnet_a_public.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-${local.env}-gw"
  })
}

resource "aws_subnet" "subnet_a" {
  cidr_block        = "172.33.0.0/20"
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${local.aws_region}a"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-${local.env}-sn-a"
  })
}

resource "aws_subnet" "subnet_b" {
  cidr_block        = "172.33.16.0/20"
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${local.aws_region}b"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-${local.env}-sn-b"
  })
}

resource "aws_subnet" "subnet_a_public" {
  cidr_block        = "172.33.32.0/20"
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${local.aws_region}a"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-${local.env}-sn-a-public"
  })
}

resource "aws_subnet" "subnet_b_public" {
  cidr_block        = "172.33.48.0/20"
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${local.aws_region}b"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-${local.env}-sn-b-public"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.igw.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-${local.env}-rt-public"
  })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-${local.env}-rt-private"
  })
}

resource "aws_route_table_association" "subnet_a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "subnet_b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "subnet_a_public" {
  subnet_id      = aws_subnet.subnet_a_public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "subnet_b_public" {
  subnet_id      = aws_subnet.subnet_b_public.id
  route_table_id = aws_route_table.public.id
}