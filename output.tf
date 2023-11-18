output "show-public-dns" {
  value = aws_instance.ec2-wordpress.public_dns
}

output "show-public-ip" {
  value = aws_instance.ec2-wordpress.public_ip
}