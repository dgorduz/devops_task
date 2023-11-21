packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.6"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "sys_pass" {
  default     = ""
  description = "The password used to connect to the instance via WinRM."
  sensitive   = true
  type        = string
}

variable "build_region" {
  default     = "us-east-1"
  description = "The region in which to retrieve the base AMI from and build the new AMI."
  type        = string
}

variable "whitelist_port" {
  default     = "8080"
  description = "whitelist port for blazor app to be accessible"
  type        = number
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "windows-AMI" {
  ami_name      = "windows-AMI-${local.timestamp}"
  instance_type = "t2.medium"
  region        = "${var.build_region}"
  communicator  = "winrm"
  source_ami_filter {
    filters = {
      name                = "Windows_Server-2022-English-Full-Base-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  user_data_file = "./src/autogen_passw_bootstrap.txt"

  winrm_insecure = true
  winrm_use_ssl  = true
  winrm_username = "Administrator"
  winrm_timeout  = "20m"
}

build {
  name = "build_windows_AMI"
  sources = [
    "source.amazon-ebs.windows-AMI"
  ]

  provisioner "powershell" {
    environment_vars = [
      "Port=${var.whitelist_port}"
    ]
    scripts = [
            "./src/config_env.ps1"
        ]
  }

  provisioner "powershell" {
    environment_vars = [
        "win_pass=${var.sys_pass}"
     ]
    inline = [
            "net user Administrator $env:win_pass"
        ]
  }

}

