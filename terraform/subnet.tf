resource "aws_subnet" "my_subnet" {
  vpc_id = var.vpc-id
  cidr_block = "172.31.0.0/20"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.name}-subnet"
  }
}