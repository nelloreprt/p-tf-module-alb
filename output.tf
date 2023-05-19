output "alb" {
  value = "aws_lb.main"
}

# sending output of >> "aws_lb_listener" "main"
output "listener" {
  value = "aws_lb_listener.main"
}