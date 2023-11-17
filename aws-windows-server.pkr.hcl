packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.6"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "windows-server" {
  ami_name      = "windows-server-jenkins-proof"
  instance_type = "t2.medium"
  region        = "us-east-1"
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
  user_data_file = "./src/autogenerated_password_https_bootstrap.txt"

  //   force_deregister = true

  //   user_data_file = "./bootstrap_win.txt"
  winrm_insecure = true
  winrm_password = "SuperS3cr3t!!!!"
  winrm_use_ssl  = true
  winrm_username = "Administrator"
  winrm_timeout  = "20m"
}

build {
  name = "devops-task"
  sources = [
    "source.amazon-ebs.windows-server"
  ]

  provisioner "powershell" {
    inline = [
      # Install .NET Framework 3.5
      "Install-WindowsFeature -Name NET-Framework-Core",

      # Install Chocolatey
      "iex ((new-object net.webclient).DownloadString(\"https://chocolatey.org/install.ps1\"))",

      # Install JDK 11 
      "choco install openjdk --version=17.0.1 -y",
    ]
  }

  provisioner "powershell" {
    inline = [
      "Write-Host \"Your Java version is:\"",
      "java -version"
    ]
  }

  provisioner "powershell" {
    environment_vars = [
      "Port = 8080"
    ]
    inline = [
      # Install Jenkins using Chocolatey
      "choco install Jenkins -y",
      "Set-Service -Name Jenkins -StartupType Automatic",

      "Write-Host \"Set the port Jenkins uses\"",
      "$env:Config = Get-Content -Path \"$ENV:ProgramFiles\\Jenkins\\Jenkins.xml\"",
      "$env:NewConfig = $env:Config -replace \"--httpPort=[0-9]*\\s", "--httpPort=$ENV:Port \"",
      "Set-Content -Path \"$env:ProgramFiles\\Jenkins\\Jenkins.xml\" -Value $env:NewConfig -Force",
      "Start-Sleep -Seconds 30",
      "Write-Host \"Restarting service\"",
      "Restart-Service -Name Jenkins"
    ]
  }

  provisioner "powershell" {
    scripts = [
      "./src/whitelist_win_port.ps1"
    ]
  }

}

