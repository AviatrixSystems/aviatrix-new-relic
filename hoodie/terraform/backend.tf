resource "aws_instance" "ubuntu-backend" {
  key_name      = aws_key_pair.ubuntu.key_name
  ami           = coalesce(var.ami_id, data.aws_ami.ubuntu.id)
  instance_type = var.ec2_type

  tags = {
    Name = "${local.prefix}/vm-backend"
    keep = "true"
  }

  vpc_security_group_ids = [
    aws_security_group.app-security-group.id
  ]

  subnet_id = data.aws_subnet.hoodie_subnet.id

  provisioner "file" {
    source      = "./backend-scripts/"
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
      "sudo /tmp/backend-create.sh | tee /tmp/backend-create.log",
      "sudo /tmp/backend-configure.sh | tee /tmp/backend-configure.log",
      "sudo /tmp/backend-start.sh ${aws_eip.ubuntu-mariadb.public_ip}:3306 ${local.db_user} ${local.db_pass} | tee /tmp/backend-start.log",
      "echo ${self.public_ip}"
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
    aws_instance.ubuntu-mariadb
  ]

  lifecycle {
    ignore_changes = [
      ami,  // don't reprovision just because ami changes
    ]
  }
}

# Provides an Elastic IP resource.
resource "aws_eip" "ubuntu-backend" {
  domain      = "vpc"
  instance = aws_instance.ubuntu-backend.id

  tags = {
    Name = "${local.prefix}/vm-backend-eip"
  }
}
