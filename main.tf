
# Create VPC 
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.1"
  
  name       = var.vpc_name
  cidr       = var.cidr_block_vpc
  create_igw = var.igw_vpc

# Config Aviability Zone and Subnet
  azs                  = var.azs_to_vpc
  public_subnets       = var.cidr_public_subnets_to_vpc
  private_subnets      = var.cidr_private_subnets_to_vpc
  public_subnet_names  = var.public_subnet_names
  private_subnet_names = var.private_subnet_names

# Config NAT Gateway
  enable_nat_gateway     = var.create_nat_gw_to_vpc
  single_nat_gateway     = var.single_nat_gw_to_vpc
  one_nat_gateway_per_az = var.one_nat_gw_per_azs_vpc

# Default Security Group
  default_security_group_name    = var.def_sg_name_vpc
  default_security_group_ingress = var.def_sg_ingress_vpc
  default_security_group_egress  = var.def_sg_egress_vpc

#Tags in VPC
  tags             = var.common_tags_to_vpc
  igw_tags         = var.igw_tags_vpc
  nat_eip_tags     = var.nat_eip_tags_vpc
  nat_gateway_tags = var.nat_tags_vpc

}


# Create Public SG for VPC of Project
resource "aws_security_group" "public_jenkins_master" {
  vpc_id = module.vpc.vpc_id
  name   = var.name_public_sg_jenkins_master

#Rules to ingress trafic
  dynamic "ingress" {
    for_each = var.ingress_port_to_jenkins_master_sg

    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = var.cidr_to_ingress_port_jenkins_master
    }
  }


# Rule for egress to all internet
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = var.cidr_to_egress_port_jenkins_master
  }

# Tags SG for Jenkins Server 
  tags = var.tags_sg_jenkins_master
}