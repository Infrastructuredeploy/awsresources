# data "aws_instances" "instance" {
#   instance_tags = {
#     Name = "instance"
#   }
# }
# resource "aws_lb" "prod_elb" {
#   name               = "prodelb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.demosg.id]
#   subnets            = [for subnet in aws_subnet.mysubnet : subnet.id]

#   enable_deletion_protection = false

#   tags = {
#     Environment = "prod_elb"
#   }
# }

# # Configure aws target group for alb

# resource "aws_lb_target_group" "instance_ngnix" {
#   name        = "oma-lb-tg"
#   port        = 80
#   protocol    = "HTTP"
#   vpc_id      = aws_vpc.myvpc.id
#   #target_type = "alb"

#   health_check {
#     enabled = true
#     interval = 300
#     path    = "/"
#     timeout = 60
#     matcher = "200"
#     healthy_threshold = 5
#     unhealthy_threshold = 5

#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# # # Configure aws target group attachment for alb

# # resource "aws_lb_target_group_attachment" "instance_ngnix" {
# #   count            = length(data.aws_instances.instance.ids)
# #   target_group_arn = aws_lb_target_group.instance_ngnix.arn
# #   target_id        = data.aws_instances.instance.ids[count.index]
# #   port             = 80
# # }

# # Configure aws Listener for alb
# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.prod_elb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.instance_ngnix.arn
#   }
# }



