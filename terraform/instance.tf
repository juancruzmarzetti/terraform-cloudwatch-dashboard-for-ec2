resource "aws_instance" "juan-instance" {
    ami = "ami-04b70fa74e45c3917"
    instance_type = "t2.micro"
    subnet_id = var.subnet_id
    key_name = aws_key_pair.my_key_pair.key_name
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.ssh.id]

    tags = {
        Name = "${var.name}-instance"
    }
}