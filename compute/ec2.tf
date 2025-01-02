resource "tls_private_key" "formation_private_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "aws_key_pair" "opentofu_generated_key" {
  key_name   = var.keyname
  public_key = tls_private_key.formation_private_key.public_key_openssh
}

resource "local_file" "formation_opentofu_key" {
  content  = tls_private_key.formation_private_key.private_key_pem
  filename = "${var.keyname}.pem"
}

resource "aws_instance" "formation_web_server" {
  ami                    = data.aws_ami.ubuntu.id # Ubuntu Server 24.04 LTS (HVM),EBS General Purpose (SSD) Volume Type
  instance_type          = var.instance_types["micro"]
  subnet_id              = aws_subnet.formation_public_subnet[0].id
  vpc_security_group_ids = [aws_security_group.formation_sg.id]
  key_name               = aws_key_pair.formation_key.key_name
  tags = {
    stage = "test"
    name  = "formation_web_server"
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(local_file.formation_opentofu_key.filename)
  }
  provisioner "remote-exec" {
    inline = [
      "nc -zv -w 1 -i 1 ${aws_instance.formation_db_server.private_ip} 22",
    ]
  }
}

resource "aws_instance" "formation_db_server" {
  ami                    = data.aws_ami.ubuntu.id # Ubuntu Server 24.04 LTS (HVM),EBS General Purpose (SSD) Volume Type
  instance_type          = var.instance_types["micro"]
  subnet_id              = aws_subnet.formation_private_subnet[1].id
  vpc_security_group_ids = [aws_security_group.formation_sg.id]
  key_name               = aws_key_pair.formation_key.key_name
  tags = {
    stage = "test"
    name  = "formation_db_server"
  }
}