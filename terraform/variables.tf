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

variable "grafana_port" {
  description = "Port Number for Grafana"
  type        = number
  default     = 3000
}

variable "prometheus_port" {
  description = "Port Number for Prometheus"
  type        = number
  default     = 9090
}
variable "subnet_ids" {
  description = "List of subnet IDs for the ECS service"
  type        = list(string)
  default = [ "subnet-0f83db295df682a0e", "subnet-04da35f67007a729b","subnet-0eaf4f1fe4dbb8ec0", "subnet-0a2e10203608b4734", "subnet-0e5c849717332b9a3", "subnet-015eef805d1222efe" ]
}
variable "logging_port" {
  description = "Port Number for Logging"
  type        = number
  default     = 8000
}