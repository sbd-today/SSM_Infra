resource "aws_eip" "app-eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "vpc_nat" {
  depends_on = [
    aws_eip.app-eip
  ]
  # Allocating the Elastic IP to the NAT Gateway!
  allocation_id = aws_eip.app-eip.id

  # Associating it in the Public Subnet!
  subnet_id = aws_subnet.vpc_subnet_pub_01.id

  tags = {
    Name = "VPC NAT"
  }
}


resource "aws_route_table" "vpcnat-rt" {
  depends_on = [
    aws_nat_gateway.vpc_nat
  ]

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.vpc_nat.id
  }

  tags = {
    Name = "Route Table for NAT Gateway"
  }

}

resource "aws_route_table_association" "private_route_table_association_subnet_01" {
  subnet_id      = aws_subnet.vpc_subnet_priv_01.id
  route_table_id = aws_route_table.vpcnat-rt.id
}

resource "aws_route_table_association" "private_route_table_association_subnet_02" {
  subnet_id      = aws_subnet.vpc_subnet_priv_02.id
  route_table_id = aws_route_table.vpcnat-rt.id
}

resource "aws_route_table_association" "private_route_table_association_subnet_03" {
  subnet_id      = aws_subnet.vpc_subnet_priv_02.id
  route_table_id = aws_route_table.vpcnat-rt.id
}