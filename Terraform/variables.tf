variable "aws_region" {
    description = "AWS region to deploy resources"
    type = string
    default = "us-east-1"
}

variable "app_name" {
    description = "Application name used for naming resources"
    type = string
    default = "cloud-project"
}

variable "container_port" {
    description = "Port on which the container will listen"
    type = number
    default = 8080
}