##############################################################################
# Internal Application Load Balancer
##############################################################################
resource "aws_lb" "this" {
  name               = var.alb_name
  internal           = true
  load_balancer_type = "application"
  # Ensure these variables/IDs allow Port 80 traffic
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(var.common_tags, { Name = var.alb_name })
}

##############################################################################
# Target Group – forwards HTTP (80) to EC2 instances
##############################################################################
resource "aws_lb_target_group" "this" {
  name        = "${var.alb_name}-TG"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 10
    interval            = 30
    matcher             = "200-399"
  }

  tags = merge(var.common_tags, { Name = "${var.alb_name}-TG" })
}

##############################################################################
# Listener – HTTP 80 (Replaces HTTPS 443 to skip ACM)
##############################################################################
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"
  # ssl_policy and certificate_arn are removed because we are not using HTTPS

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

##############################################################################
# Target Group Attachment – register EC2 instance
##############################################################################
resource "aws_lb_target_group_attachment" "ec2" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id         = var.ec2_instance_id
  port             = 80
}