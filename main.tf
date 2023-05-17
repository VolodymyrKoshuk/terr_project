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


# Create Public SG for VPC of Project to Jenkins Master
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



# Create SG for VPC of Project Jenkins Agent
resource "aws_security_group" "jenkins_node" {
  vpc_id = module.vpc.vpc_id
  name   = var.name_sg_jenkins_node

#Rules to ingress trafic
  dynamic "ingress" {
    for_each = var.ingress_port_to_jenkins_node_sg

    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = var.cidr_to_ingress_port_jenkins_node
    }
  }


# Rule for egress to all internet
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = var.cidr_to_egress_port_jenkins_node
  }

# Tags SG for Jenkins Agent Server 
  tags = var.tags_sg_jenkins_node
}


# Create Jenkins Server
module "ec2_jenkins_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.0.0"

  for_each = toset(var.number_of_master_jenkins_servers)

  name                        = "${var.name_jenkins_server} #${each.value}"
  ami                         = var.ami_jenkins_server  
  instance_type               = var.instance_type_jenkins_server
  key_name                    = var.key_name_jenkins_server
  associate_public_ip_address = var.associate_pub_ip_jenkins_server
  iam_instance_profile        = var.iam_instance_profile_jenkins_server
  vpc_security_group_ids      = [aws_security_group.public_jenkins_master.id]
  subnet_id                   = module.vpc.public_subnets[var.subnet_to_jenkins_server]

  root_block_device           = var.rbd_to_jenkins_server

  tags                        = var.default_tags_to_jenkins_server

}


# Create Jenkins Node Ansible Server
module "ec2_jenkins_node_ansible" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.0.0"

  for_each = toset(var.number_of_ansible_jenkins_servers)

  name                        = "${var.name_jenkins_ansible_server} #${each.value}"
  ami                         = var.ami_jenkins_ansible_server  
  instance_type               = var.instance_type_jenkins_ansible_server
  key_name                    = var.key_name_jenkins_ansible_server
  associate_public_ip_address = var.associate_pub_ip_jenkins_ansible_server
  iam_instance_profile        = var.iam_instance_profile_jenkins_ansible_server
  vpc_security_group_ids      = [aws_security_group.jenkins_node.id]
  subnet_id                   = module.vpc.public_subnets[var.subnet_to_jenkins_ansible_server]

  root_block_device           = var.rbd_to_jenkins_ansible_server

  tags                        = var.default_tags_to_jenkins_ansible_server

}


# Create Jenkins Node AWSCLI Server
module "ec2_jenkins_node_awscli" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.0.0"

  for_each = toset(var.number_of_awscli_jenkins_servers)

  name                        = "${var.name_jenkins_awscli_server} #${each.value}"
  ami                         = var.ami_jenkins_awscli_server  
  instance_type               = var.instance_type_jenkins_awscli_server
  key_name                    = var.key_name_jenkins_awscli_server
  associate_public_ip_address = var.associate_pub_ip_jenkins_awscli_server
  iam_instance_profile        = var.iam_instance_profile_jenkins_awscli_server
  vpc_security_group_ids      = [aws_security_group.jenkins_node.id]
  subnet_id                   = module.vpc.public_subnets[var.subnet_to_jenkins_awsclie_server]

  root_block_device           = var.rbd_to_jenkins_awscli_server

  tags                        = var.default_tags_to_jenkins_awscli_server


  depends_on = [aws_ecr_repository.nodejs_app1]
}


# Create ECR for node.js app

resource "aws_ecr_repository" "nodejs_app1" {
  name                 = var.name_ecr_nodejs_app1
  image_tag_mutability = var.mutability_ecr_nodejs_app1

  image_scanning_configuration {
    scan_on_push = var.scanning_ecr_nodejs_app1
  }
  
  tags = var.default_tags_to_ecr_nodejs_app1
}


#Create S3 bucket for CloudFront dev
resource "aws_s3_bucket" "bucket_dev" {
  bucket = var.bucket_name_dev
  acl    = "private"
}

#Create S3 bucket for CloudFront prod
resource "aws_s3_bucket" "bucket_prod" {
  bucket = var.bucket_name_prod
  acl    = "private"
}


#Create CloudFront
resource "aws_cloudfront_distribution" "website_distribution" {
  origin {
    domain_name = aws_s3_bucket.bucket_prod.bucket_regional_domain_name
    origin_id   = "prod"
    origin_path = ""
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.access_prod.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = aws_s3_bucket.bucket_dev.bucket_regional_domain_name
    origin_id   = "dev"
    origin_path = ""
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.access_dev.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  http_version        = "http2"
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id = "prod"

    viewer_protocol_policy     = "redirect-to-https"
    allowed_methods            = ["GET", "HEAD"]
    cached_methods             = ["GET", "HEAD"]
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  ordered_cache_behavior {
    path_pattern     = "/dev/*"
    target_origin_id = "dev"

    viewer_protocol_policy     = "redirect-to-https"
    allowed_methods            = ["GET", "HEAD"]
    cached_methods             = ["GET", "HEAD"]
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Role      = "website distribution"
    Terraform = true
  }
}


resource "aws_cloudfront_origin_access_identity" "access_prod" {}

resource "aws_cloudfront_origin_access_identity" "access_dev" {}


resource "aws_s3_bucket_policy" "bucket_policy_prod" {
  bucket = "${aws_s3_bucket.bucket_prod.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "CloudFrontAccessPolicy",
  "Statement": [
    {
      "Sid": "AllowCloudFrontAccess",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_cloudfront_origin_access_identity.access_prod.iam_arn}"
      },
      "Action": "s3:GetObject",
      "Resource": "${aws_s3_bucket.bucket_prod.arn}/*"
    }
  ]
}
EOF
}

resource "aws_s3_bucket_policy" "bucket_policy_dev" {
  bucket = "${aws_s3_bucket.bucket_dev.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "CloudFrontAccessPolicy",
  "Statement": [
    {
      "Sid": "AllowCloudFrontAccess",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_cloudfront_origin_access_identity.access_dev.iam_arn}"
      },
      "Action": "s3:GetObject",
      "Resource": "${aws_s3_bucket.bucket_dev.arn}/*"
    }
  ]
}
EOF
}