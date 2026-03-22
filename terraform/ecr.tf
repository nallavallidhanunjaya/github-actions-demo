resource "aws_ecr_repository" "app_repository" {
  name = var.app_name
}
resource "aws_ecr_repository" "prometheus_repository" {
  name = "prometheus"
}