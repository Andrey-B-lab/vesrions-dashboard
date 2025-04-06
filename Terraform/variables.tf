# the values are in terraform.tfvars file
variable "my_ip_address" {
  description = "My IP address"
  type        = string
  sensitive   = true
}

variable "key_pair_name" {
  description = "My key pair name"
  type        = string
  sensitive   = true
}
