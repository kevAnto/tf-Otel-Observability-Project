output "ec2_public_ip" {
  value = aws_instance.otel-server.public_ip
}