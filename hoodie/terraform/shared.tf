
# ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-
data "aws_ami" "ubuntu" {
  most_recent      = true

  # name_regex       = "^ubuntu-focal-20.04-amd64-server-.*"
  filter {
    name   = "name"
    //values = ["*ubuntu-*-22.04-amd64-server-*"]
    values = ["*ubuntu-focal-20.04-amd64-server-*"]
  }

  owners           = ["099720109477"]
  #filter {
  #  name   = "owner-id"
  #  values = ["099720109477"]
  #}

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}



