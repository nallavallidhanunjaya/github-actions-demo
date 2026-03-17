variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "The name of the application"
  type        = string
  default     = "github-actions-demo"
}

variable "container_port" {
  description = "Port Number for the Container"
  type        = number
  default     = 5000
}