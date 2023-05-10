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

#-------------------------------------------------------------------------------

#Variables to Public Security Group for jenkins Master
variable "name_public_sg_jenkins_master" {
    description = "Name to public Security Group for Jenkins Master"
    type = string
    default = "Security Group of Jenkins Master"
}

variable "ingress_port_to_jenkins_master_sg" {
    description = "List ingress port to public servers"
    type = list(string)
    default = ["8080", "22", "50000"]
}

variable "cidr_to_ingress_port_jenkins_master" {
    description = "CIDR Block to ingress ports to jenkins Server"
    type = list(string)
    default = ["0.0.0.0/0"]
}

variable "cidr_to_egress_port_jenkins_master" {
    description = "CIDR Block to egress trafic to network"
    type = list(string)
    default = ["0.0.0.0/0"]
}

variable "tags_sg_jenkins_master" {
    description = "Tags to Seurity Group for Jenkins Server"
    type = map
    default = {
        Role = "Security group for Jenkins Server"
        Terraform = true
        education = true
        course    = "Course Project"
  }
}


#-------------------------------------------------------------------------------

#Variables to Public Security Group for jenkins Agents
variable "name_sg_jenkins_node" {
    description = "Name to public Security Group for Jenkins Node"
    type = string
    default = "Security Group of Jenkins Node"
}

variable "ingress_port_to_jenkins_node_sg" {
    description = "List ingress port to jenkins node servers"
    type = list(string)
    default = ["50000", "22"]
}

variable "cidr_to_ingress_port_jenkins_node" {
    description = "CIDR Block to ingress ports to Jenkins Node"
    type = list(string)
    default = ["10.24.0.0/16"]
}

variable "cidr_to_egress_port_jenkins_node" {
   description = "CIDR Block to egress trafic to Jenkins Nodes"
    type = list(string)
    default = ["0.0.0.0/0"]
}

variable "tags_sg_jenkins_node" {
    description = "Tags to Seurity Group for Jenkins Server"
    type = map
    default = {
        Role = "Security group for Jenkins Node Servers"
        Terraform = true
        education = true
        course    = "Course Project"
  }
}


#-------------------------------------------------------------------------------

# Variables for Jenkins Server

variable "number_of_master_jenkins_servers" {
    description = "variable to multiple create Jenkins Master Servers"
    type = list
    default = ["first"]
}

variable "name_jenkins_server" {
    description = "variable to name jenkins server"
    type = string
    default = "Jenkins Master"
}

variable "ami_jenkins_server" {
    description = "ami to Jenkins Server"
    type = string
    default = "ami-0ee3b62577567f454"
}

variable "instance_type_jenkins_server" {
    description = "variable to instance type jenkins server"
    type = string
    default = "t3.micro"
}

variable "key_name_jenkins_server" {
    description = "variable to key_name jenkins server"
    type = string
    default = "vova-key-linuxaws-prod-stokholm"
}

variable "associate_pub_ip_jenkins_server" {
    description = "variable to associate public ip address to jenkins server"
    type = bool
    default = true
}

variable "iam_instance_profile_jenkins_server" {
    description = "variable to iam instance profile jenkins servers"
    type = string
    default = "AmazonSSMRoleForInstancesQuickSetup"
}

variable "subnet_to_jenkins_server" {
    description = "variable to subnet to jenkins server (0=subnet-a, 1=subnet-b, 2=subnet-c)"
    type = number
    default = 0
}

variable "rbd_to_jenkins_server" {
    description = "variable to root block device for jenkins server"
    type = list(any)
    default = [
    {
      volume_type           = "gp3"
      volume_size           = "10"
      delete_on_termination = "true"
    }
  ]
}

variable "default_tags_to_jenkins_server" {
    description = "Common Tags to apply to Module ec2_jenkins_server"
    type = map
    default = {
    Role      = "Jenkins Server"
    Terraform = true
    education = true
    course    = "Course Project"
  }
}

#-------------------------------------------------------------------------------

# Variables for Jenkins Node Ansible Server

variable "number_of_ansible_jenkins_servers" {
    description = "variable to multiple create Jenkins Node Ansible Servers"
    type = list
    default = ["first"]
}

variable "name_jenkins_ansible_server" {
    description = "variable to name jenkins node ansible server"
    type = string
    default = "Jenkins Agent Ansible"
}

variable "ami_jenkins_ansible_server" {
    description = "ami to Jenkins Node Ansible Server"
    type = string
    default = "ami-0993a5ffcf00a7172"
}

variable "instance_type_jenkins_ansible_server" {
    description = "variable to instance type jenkins ansible server"
    type = string
    default = "t3.micro"
}

variable "key_name_jenkins_ansible_server" {
    description = "variable to key_name jenkins ansible server"
    type = string
    default = "vova-key-linuxaws-prod-stokholm"
}

variable "associate_pub_ip_jenkins_ansible_server" {
    description = "variable to associate public ip address to jenkins node ansible server"
    type = bool
    default = true
}

variable "iam_instance_profile_jenkins_ansible_server" {
    description = "variable to iam instance profile jenkins node ansible servers"
    type = string
    default = "ReadOnlyEC2AndECR"
}

variable "subnet_to_jenkins_ansible_server" {
    description = "variable to subnet to jenkins ansible server (0=subnet-a, 1=subnet-b, 2=subnet-c)"
    type = number
    default = 1
}

variable "rbd_to_jenkins_ansible_server" {
    description = "variable to root block device for jenkins ansible server"
    type = list(any)
    default = [
    {
      volume_type           = "gp3"
      volume_size           = "8"
      delete_on_termination = "true"
    }
  ]
}

variable "default_tags_to_jenkins_ansible_server" {
    description = "Common Tags to apply to Module ec2_jenkins_node_ansible"
    type = map
    default = {
    Role      = "Jenkins Agent"
    Ansible   = true
    AWSCLI    = false
    Terraform = true
    education = true
    course    = "Course Project"
  }
}


#-------------------------------------------------------------------------------

# Variables for Jenkins Node AWSCLI Server

variable "number_of_awscli_jenkins_servers" {
    description = "variable to multiple create Jenkins Node AWSCLI Servers"
    type = list
    default = ["first"]
}

variable "name_jenkins_awscli_server" {
    description = "variable to name jenkins node awscli server"
    type = string
    default = "Jenkins Agent AWSCLI"
}

variable "ami_jenkins_awscli_server" {
    description = "ami to Jenkins Node AWSCLI Server"
    type = string
    default = "ami-0993a5ffcf00a7172"
}

variable "instance_type_jenkins_awscli_server" {
    description = "variable to instance type jenkins awscli server"
    type = string
    default = "t3.micro"
}

variable "key_name_jenkins_awscli_server" {
    description = "variable to key_name jenkins awscli server"
    type = string
    default = "vova-key-linuxaws-prod-stokholm"
}

variable "associate_pub_ip_jenkins_awscli_server" {
    description = "variable to associate public ip address to jenkins node awscli server"
    type = bool
    default = true
}

variable "iam_instance_profile_jenkins_awscli_server" {
    description = "variable to iam instance profile jenkins node awscli servers"
    type = string
    default = "ECRSSMRoleForEC2"
}

variable "subnet_to_jenkins_awsclie_server" {
    description = "variable to subnet to jenkins awscli server (0=subnet-a, 1=subnet-b, 2=subnet-c)"
    type = number
    default = 2
}

variable "rbd_to_jenkins_awscli_server" {
    description = "variable to root block device for jenkins awscli server"
    type = list(any)
    default = [
    {
      volume_type           = "gp3"
      volume_size           = "8"
      delete_on_termination = "true"
    }
  ]
}

variable "default_tags_to_jenkins_awscli_server" {
    description = "Common Tags to apply to Module ec2_jenkins_node_awscli"
    type = map
    default = {
    Role      = "Jenkins Agent"
    Ansible   = true
    AWSCLI    = false
    Terraform = true
    education = true
    course    = "Course Project"
  }
}


#------------------------------------------------------------------------------

# ECR node.js app1 

variable "name_ecr_nodejs_app1" {
    description = "Name for ecr node.js app1"
    type = string
    default = "nodejs_app1"
}

variable "mutability_ecr_nodejs_app1" {
    description = "Mutable configuration to git tag for ecr node.js app1"
    type = string
    default = "MUTABLE"
}

variable "scanning_ecr_nodejs_app1" {
    description = "Image scanning configuration for ecr node.js app1"
    type = bool
    default = true
}

variable "default_tags_to_ecr_nodejs_app1" {
    description = "Common Tags to apply to ecr node.js app1"
    type = map
    default = {
    Terraform = true
    Role      = "ECR for node.js app1"
    education = true
    course    = "Course Project"
  }
}