# ==================================
# cloud watch log
# ==================================
resource "aws_cloudwatch_log_group" "nginx_log" {
  name              = "/ecs/${var.user}/nginx"
  retention_in_days = 7
}
