variable "sys_pass1" {
  default     = "some_string"
  description = "The password used to connect to the instance via WinRM."
#   sensitive   = true
  type        = string
}

variable "sys_pass2" {
  default     = "some_string2"
  description = "The password used to connect to the instance via WinRM."
#   sensitive   = true
  type        = string
}

source "null" "example" {
    # new_var = "${var.sys_pass1}"
    # new_var1 = var.sys_pass2
    communicator = "none"
}

build {
  sources = [
    "source.null.example"
  ]

  provisioner "shell-local" {
    environment_vars = ["NEW_VAR=${var.sys_pass1}", "NEW_VAR1=${var.sys_pass2}"]
    inline           = [
      "echo NEW_VAR is: $NEW_VAR",
      "echo NEW_VAR1 is: $NEW_VAR1"
    ]
  }
}
