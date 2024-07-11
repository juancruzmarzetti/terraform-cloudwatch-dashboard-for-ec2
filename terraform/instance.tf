resource "aws_instance" "juan-instance" {
    ami = "ami-04b70fa74e45c3917"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.my_subnet.id
    key_name = "my-tf-test-ec2-keypair-name"

    tags = {
        Name = "${var.name}-instance"
    }
}