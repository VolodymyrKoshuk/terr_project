# Main variabes to VPC
variable "vpc_name" {
    description = "Name to VPC"
    type = string
    default = "My_VPC_Project"
}

variable "cidr_block_vpc" {
    description = "CIDR block to VPC"
    type = string
    default = "10.24.0.0/16"
}

variable "igw_vpc" {
    description = "Create Internet GW to VPC"
    type = bool
    default = true
}

# Config Aviability Zone and Subnet
variable "azs_to_vpc" {
    description = "Availabilit Zones to VPC"
    type = list(string)
    default = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
}

variable "cidr_public_subnets_to_vpc" {
    description = "CIDR block to public subnets to VPC"
    type = list(string)
    default = ["10.24.11.0/24", "10.24.21.0/24", "10.24.31.0/24"]
}

variable "cidr_private_subnets_to_vpc" {
    description = "CIDR block to private subnets to VPC"
    type = list(string)
    default = ["10.24.12.0/24", "10.24.22.0/24", "10.24.32.0/24"]
}

variable "public_subnet_names" {
    description = "Names for public subnets"
    type        = list(string)
    default     = ["public-a", "public-b", "public-c"]
}

variable "private_subnet_names" {
    description = "Names for private subnets"
    type        = list(string)
    default     = ["private-a", "private-b", "private-c"]
}

# Config NAT Gateway
variable "create_nat_gw_to_vpc" {
    description = "Create NAT GW to VPC"
    type = bool
    default = false
}

variable "single_nat_gw_to_vpc" {
    description = "Single NAT GW to VPC"
    type = bool
    default = false
}

variable "one_nat_gw_per_azs_vpc" {
    description = "One NAT GW per Availability Zone to VPC"
    type = bool
    default = false
}

# Default Security Group
variable "def_sg_name_vpc" {
    description = "Name default security group in VPC"
    type = string
    default = "Default_Security_Grop_Project"
}

variable "def_sg_ingress_vpc" {
    description = "Rules ingress for security group to VPC"
    type = list(any)
    default = [{
        description      = "Default ingress SG"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = "10.24.0.0/16"
  }]
}

variable "def_sg_egress_vpc" {
    description = "Rules egress for security group to VPC"
    type = list(any)
    default = [{
        description      = "Default egress SG"
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = "10.24.0.0/16"
  }]
}

# All Tags in VPC
variable "common_tags_to_vpc" {
    description = "Common Tags to apply to all VPC"
    type = map
    default = {
        Terraform = true
        education = true
        course    = "Course Project"
  }
}

variable "igw_tags_vpc" {
    description = "Tags to Internet GW in VPC"
    type = map
    default = { 
        Name = "IGW for VPC of Project"
  }
}

variable "nat_eip_tags_vpc" {
    description = "Tags to NAT EIPs in VPC"
    type = map
    default = { 
        Name = "EIPs for NAT GW in VPC of Project"
  }
}

variable "nat_tags_vpc" {
    description = "Tags to NAT GW in VPC"
    type = map
    default = { 
        Name = "NAT GW for Private Subnet in VPC of Project"
  }
}
