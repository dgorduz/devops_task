provider "aws" {
  region = "us-east-1"
}

locals {
  instance_type = "t2.micro"
  most_recent   = true
}

data "aws_ami" "ubuntu" {
  filter {
    name   = "ubuntu_from_jenkins"
    values = ["ubuntu-*"]
  }
  most_recent = local.most_recent
}

resource "aws_key_pair" "this" {
  key_name   = "new_tf_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "web" {
  ami           = "ami-05c13eab67c5d8861"
  instance_type = local.instance_type
  key_name      = aws_key_pair.this.key_name
}

resource "null_resource" "remote_exec" {
  depends_on = [
    aws_instance.web
  ]
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host        = aws_instance.web.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "mkdir proj_docker",
      "cd proj_docker | touch Dockerfile"
    ]
  }
}

