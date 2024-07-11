resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-tf-test-ec2-keypair-name"
  public_key = file("~/.ssh/id_rsa.pub")
}