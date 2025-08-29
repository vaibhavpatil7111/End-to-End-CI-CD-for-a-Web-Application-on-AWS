output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}

# output "app_private_ip" {
#   value = aws_instance.app_server.private_ip
# }
