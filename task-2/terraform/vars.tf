locals {
  sc_cable_cidr = "78.139.55.13/32"
  sc_fiber_cidr = "89.133.94.200/30"
  common_tags = {
    Project     = "nuvolar"
    Environment = "nonprod"
    Terraform   = true
  }
  project_name = "nuvolar"
  env          = "nonprod"
  aws_region   = "eu-central-1"
  envs         = toset(["test"])
}

variable "images" {
  type = map(string)
}

variable "root_admin_password" {
  type = string
}