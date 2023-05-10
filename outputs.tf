output "public_ip_jenkins_master" {
    value = module.ec2_jenkins_server[*].public_ip
}

output "public_ip_jenkins_ansible_nodes" {
    value = module.ec2_jenkins_node_ansible[*].public_ip
}

output "public_ip_jenkins_awscli_nodes" {
    value = module.ec2_jenkins_node_awscli[*].public_ip
}

output "url_ecr_nodejs_app1" {
    value = aws_ecr_repository.nodejs_app1.repository_url
}