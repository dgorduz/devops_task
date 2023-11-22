provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "my_windows_ami" {
  owners      = ["self"]
  most_recent = true
  filter {
    name   = "name"
    values = ["windows-AMI-*"]
  }
}

resource "aws_instance" "windows_server" {
  count = var.nr_vms
  ami           = data.aws_ami.my_windows_ami.id
  instance_type = "t2.medium"
  tags = {
    Name = "provisioned_win_${count.index}"
  }

  connection {
    type        = "winrm"
    user        = "Administrator"
    password    = var.win_pass
    timeout     = "5m"
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "git clone -b dev https://github.com/dgorduz/blazor_app_demo.git",
      "cd .\\blazor_app_demo\\"
    ]
  }
}
