# Application_Load_Balancer (internal_lb or Private_lb >> on App_subnet) (external_lb or Public_lb >> on Public_subnet)
resource "aws_lb" "main" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  # security_groups    = [aws_security_group.lb_sg.id] (not_applicable as we did not create security_groups)
  subnets            = var.subnet_ids

  enable_deletion_protection = var.enable_deletion_protection

  tags = {
    merge( var.tags, Name = "${var.env}-${var.name}-alb")

}

# Security_Group for Load_Balancer (Listner: to send traffic to a particular Target_group)
resource "aws_security_group" "lb" {
  name        = "${var.name}-${var.env}-lb-sg"
  description = "${var.name}-${var.env}-lb-sg"
  vpc_id      = var.vpc_id


egress {
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
}

ingress {
  description      = "APP"
  from_port        = 80           # inside Load_Balancer we are opening port 80
  to_port          = 80           # inside Load_Balancer we are opening port 80
  protocol         = "tcp"
  cidr_blocks      = var.cidr_block     # here we have to specify which subnet should access the LB (not in terms of subnet_id, but in terms of cidr_block)
}

  tags = {
    merge (var.tags, Name = "${var.name}-${var.env}-lb-security-group")
}

# listner with Fixed Response
# So if any one hitting from internetwith DNS record of (Public_LB or PRIVATE_LB)
# (as the rule is NOT matching) it will throw error
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"     # Port 80 is the port number assigned to commonly used internet communication protocol
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "503- Invalid Request"
      status_code  = "503"
    }
  }
}

