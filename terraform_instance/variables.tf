variable "nr_vms" {
  default = 1
}
variable "win_pass" {
  default = ""
  description = "password to login from the Jenkins credentials"
  sensitive = true  
}