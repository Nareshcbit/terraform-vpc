
variable "region" { default = "ap-south-1"}

variable "create_vpc" { default     = true}
variable "name" { default     = "myvpc"}
variable "cidr" { default     = "10.10.0.0/16"}

variable "public_azs" { default = ["ap-south-1a"]}
variable "public_subnets" { default = ["10.10.10.0/24"]}
variable "private_azs" { default = ["ap-south-1a", "ap-south-1b"]}
variable "private_subnets" { default = ["10.10.60.0/24", "10.10.70.0/24"]}



variable "enable_ipv6" { default     = false}
variable "enable_dns_support" { default     = true}
variable "enable_dns_hostnames" { default     = true}
variable "instance_tenancy" { default     = "default"}
variable "public_subnet_cidr" { default = "10.10.0.0/24" }
variable "private_subnet_cidr" { default = "10.10.1.0/24" }


variable "common_tags" {
  type        = map(string)
  default = {
      system_created = "terraform",
      auto_delete = "true"
      business_unit = "corp",
      department =  "cloud-engineering",
      team = "cloud-engineering",
      cost_center ="1002345",
    }
}

variable "vpc_tags" {
  type        = map(string)
  default     = {}
}

variable "igw_tags" {
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  type        = map(string)
  default     = {}
}

variable "public_route_table_tags" {
  type        = map(string)
  default     = {}
}

variable "private_route_table_tags" {
  type        = map(string)
  default     = {}
}

variable "nat_gateway_tags" {
  type        = map(string)
  default     = {}
}
