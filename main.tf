provider "aws"{

  region = var.region

}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "terraform-nxgcloud-infra-development"
    key            = "global/infra/vpc.tfstate"
    region         = "ap-south-1"
  }
}


data "aws_availability_zones" "available" {}

resource "aws_vpc" "this" {

  cidr_block                       = var.cidr
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  assign_generated_ipv6_cidr_block = var.enable_ipv6

  tags = "${merge(
    var.common_tags,
    var.vpc_tags,
    map(
      "Name", "${var.name}"
    )
  )}"
}

resource "aws_internet_gateway" "this" {
    vpc_id = "${aws_vpc.this.id}"
    tags = "${merge(
      var.common_tags,
      var.igw_tags,
      map(
        "Name", "${var.name}-igw"
      )
    )}"
}



resource "aws_subnet" "public" {

    count = "${length(var.public_subnets)}"
    vpc_id = "${aws_vpc.this.id}"
    availability_zone = "${var.public_azs[count.index]}"
    cidr_block        = "${var.public_subnets[count.index]}"
    map_public_ip_on_launch = true

    tags = "${merge(
      var.common_tags,
      var.vpc_tags,
      map(
        "Name", "${var.name}-public-${count.index}"
      )
    )}"
}

resource "aws_subnet" "private" {

    count = "${length(var.private_subnets)}"
    vpc_id = "${aws_vpc.this.id}"
    availability_zone = "${var.private_azs[count.index]}"
    cidr_block        = "${var.private_subnets[count.index]}"
    map_public_ip_on_launch = false

    tags = "${merge(
      var.common_tags,
      var.vpc_tags,
      map(
        "Name", "${var.name}-private-${count.index}"
      )
    )}"
}

resource "aws_eip" "nat" {
  count = "${length(var.public_subnets)}"
  vpc   = true
}



resource "aws_nat_gateway" "this" {
  count         = "${length(var.public_subnets)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"

  tags = "${merge(
    var.common_tags,
    var.nat_gateway_tags,
    map(
      "Name", "${var.name}-ngw-${count.index}"
    )
  )}"
}


#Public Route Table
resource "aws_route_table" "public" {

  count = length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = "${aws_vpc.this.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.this.id}"
  }

  tags = "${merge(
    var.common_tags,
    var.public_route_table_tags,
    map(
      "Name", "${var.name}-public-${count.index}"
    )
  )}"

}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id,0)
}

resource "aws_default_security_group" "default" {
  vpc_id           = "${aws_vpc.this.id}"

  tags = "${merge(
    var.common_tags,
    var.default_security_group_tags,
    map(
      "Name", "${var.name}-default"
    )
  )}"
}
