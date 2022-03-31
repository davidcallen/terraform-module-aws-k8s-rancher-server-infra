output "rancher_node_ip" {
  value = aws_instance.rancher_server.private_ip
}
output "rancher_server_public_ip" {
  value = aws_instance.rancher_server.public_ip
}
output "rancher_server_private_ip" {
  value = aws_instance.rancher_server.private_ip
}
output "node_username" {
  value = local.node_username
}
