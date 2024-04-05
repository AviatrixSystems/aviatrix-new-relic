
locals {
  db_pass = length(var.db_pass)>0 ? var.db_pass : "@@password-${var.prefix}@@"
  db_user = var.db_user
}

resource "aws_instance" "ubuntu-mariadb" {
  key_name      = aws_key_pair.ubuntu.key_name
  ami           = coalesce(var.ami_id, data.aws_ami.ubuntu.id)
  instance_type = var.ec2_type

  tags = {
    Name = "${local.prefix}/vm-mariadb"
    keep = "true"
  }

  subnet_id = data.aws_subnet.hoodie_subnet.id

  vpc_security_group_ids = [
    aws_security_group.app-security-group.id
  ]

  provisioner "file" {
    source      = "./mariadb-scripts/"
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
      "sudo /tmp/mariadb-create.sh | tee /tmp/mariadb-create.log",
      "sudo /tmp/mariadb-configure.sh ${local.db_user} ${local.db_pass} | tee /tmp/mariadb-configure.log",
      "sudo /tmp/mariadb-start.sh | tee /tmp/mariadb-start.log",
      "echo ${self.public_ip}",
      "sleep 15",  # give DB plenty of time to start up
    ]

    connection {
      agent       = false
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("key")
      host        = self.public_ip
    }
  }

  lifecycle {
    ignore_changes = [
      ami,  // don't reprovision just because ami changes
    ]
  }
}

# Provides an Elastic IP resource.
resource "aws_eip" "ubuntu-mariadb" {
  domain      = "vpc"
  instance = aws_instance.ubuntu-mariadb.id

  tags = {
    Name = "${local.prefix}/vm-mariadb-eip"
  }
}
