resource "aws_vpc" "my-vpc-wordpress" {
  cidr_block = var.vpc-cidr
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_internet_gateway" "igw-wordpress" {
  vpc_id = aws_vpc.my-vpc-wordpress.id
}

resource "aws_subnet" "subnet-wordpress-public" {
  vpc_id = aws_vpc.my-vpc-wordpress.id
  cidr_block = var.cidr-subnet-wordpress-public
  availability_zone = var.az-wordpress-public
}


resource "aws_route_table" "rtb-subnet-wordpress-public" {
  vpc_id = aws_vpc.my-vpc-wordpress.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-wordpress.id
  }
}

resource "aws_route_table_association" "association-subnet-wordpress-public" {
  subnet_id = aws_subnet.subnet-wordpress-public.id
  route_table_id = aws_route_table.rtb-subnet-wordpress-public.id
}
resource "aws_security_group" "nsg-ec2-wordpress" {
  name = "Allow HTTP inbound Traffic"
  vpc_id = aws_vpc.my-vpc-wordpress.id
  ingress = [ {
    description = "Allow HTTP inbound Traffic"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
  }
  ]
  egress = [ {
    description = "Allow HTTP outbound Traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
  }
  ]
}
resource "aws_instance" "ec2-wordpress" {
  subnet_id = aws_subnet.subnet-wordpress-public.id
  vpc_security_group_ids = [ aws_security_group.nsg-ec2-wordpress.id]
  availability_zone = var.az-wordpress-public
  user_data = file("./install-wordpress.sh")
  depends_on = [ aws_internet_gateway.igw-wordpress ]
  ami = var.ami-id
  associate_public_ip_address = true
  instance_type = var.instance-wordpress-type
  root_block_device {
    volume_size = "40"
    volume_type = "gp3"
  }
}