resource "aws_instance" "ubuntu-frontend" {
  key_name      = aws_key_pair.ubuntu.key_name
  ami           = coalesce(var.ami_id, data.aws_ami.ubuntu.id)
  instance_type = var.ec2_type

  tags = {
    Name = "${local.prefix}/vm-frontend"
    keep = "true"
  }

  subnet_id = data.aws_subnet.hoodie_subnet.id

  vpc_security_group_ids = [
    aws_security_group.app-security-group.id
  ]

  provisioner "file" {
    source      = "./frontend-scripts/"
    destination = "/tmp/"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("key")
      host        = self.public_ip
    }
  }

  # Execute script on remote vm after this creation
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/*sh",
      "/tmp/frontend-create.sh | tee /tmp/frontend-create.log",
      "/tmp/frontend-configure.sh http://${aws_eip.ubuntu-backend.public_ip}:8082 | tee /tmp/frontend-configure.log",
      "/tmp/frontend-start.sh | tee /tmp/frontend-start.log",
      "echo My IP is ${self.public_ip} although that might change once the EIP is set up"
    ]

    connection {
      agent       = false
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("key")
      host        = self.public_ip
    }
  }

  depends_on = [
    aws_instance.ubuntu-backend
  ]

  lifecycle {
    ignore_changes = [
      ami,  // don't reprovision just because ami changes
    ]
  }
}

# Provides an Elastic IP resource.
resource "aws_eip" "ubuntu-frontend" {
  domain      = "vpc"
  instance = aws_instance.ubuntu-frontend.id

  tags = {
    Name = "${local.prefix}/vm-frontend-eip"
  }
}
