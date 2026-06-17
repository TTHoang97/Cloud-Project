output "app_url" {
    description = "URL of the deployed application"
    value = "http://${aws_lb.app_lb.dns_name}:${var.container_port}"
}