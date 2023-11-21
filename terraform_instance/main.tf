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
  ami           = data.aws_ami.my_windows_ami.id
  instance_type = "t2.medium"
  tags = {
    Name = "provisioned_win"
  }

  connection {
    type        = "winrm"
    user        = "Administrator"
    password    = "Suuuper$ecret1"
    timeout     = "8m"
    host        = aws_instance.windows_server.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "git clone -b dev https://github.com/dgorduz/blazor_app_demo.git",
      "cd .\\blazor_app_demo\\",
      # "powershell.exe -ExecutionPolicy Bypass -File .\\build_env.ps1",
      "Start-Process powershell.exe -ArgumentList '-ExecutionPolicy Bypass', '-File .\\build_env.ps1' -NoNewWindow"
    ]
  }
}
