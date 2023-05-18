# Application_Load_Balancer (internal_lb or Private_lb >> on App_subnet) (external_lb or Public_lb >> on Public_subnet)
resource "aws_lb" "alb" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  # security_groups    = [aws_security_group.lb_sg.id] (not_applicable as we did not create security_groups)
  subnets            = var.subnet_ids

  enable_deletion_protection = var.enable_deletion_protection

  tags = {
    merge( var.tags, Name = "${var.env}-${var.name}-alb")
  }
}