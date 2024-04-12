# # Creating Keypair for aws Ec2
# resource "aws_key_pair" "TF_key" {
#   key_name   = "TF_key"
#   public_key = tls_private_key.rsa.public_key_openssh
# }

# # RSA key of size 4096 bits
# resource "tls_private_key" "rsa" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "local_file" "TF-key" {
#   content  = tls_private_key.rsa.private_key_pem
#   filename = "tfkey"
# }

# # Create a new EC2 launch configuration. This will be used with our auto scaling group.
# resource "aws_launch_template" "launch_temp" {
#   name_prefix   = "launch_temp"
#   image_id      = "ami-080e1f13689e07408"
#   instance_type = var.instance_type
#   key_name      = "TF_key"
#   network_interfaces {
#     associate_public_ip_address = true
#     security_groups             = [aws_security_group.demosg.id]
#   }
#   user_data = base64encode(<<-EOF
#              #!/bin/bash
#              sudo apt-get update
#              sudo apt-get install -y nginx
#              sudo systemctl start nginx
#              sudo systemctl enable nginx
#              echo '<!doctype html>
#              <html lang="en"><h1>Home page!</h1></br>
#              <h3>(Instance A)</h3>
#              </html>' | sudo tee /var/www/html/index.html
#              EOF
#              )
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# # Create the auto scaling group
# resource "aws_autoscaling_group" "autoscaling_group_dev" {
#   name              = "autoscaling_group_dev"
#   min_size          = 4
#   max_size          = 6
#   #target_group_arns = ["aws_lb_target_group.instance_ngnix.arn"]
#   #security_groups     = [aws_security_group.demosg.id]
#   vpc_zone_identifier = flatten([for subnet in aws_subnet.mysubnet : subnet.id])
#   launch_template {
#     id      = aws_launch_template.launch_temp.id
#     version = aws_launch_template.launch_temp.latest_version
#   }
#   tag {
#     key                 = "Name"
#     value               = "autoscaling-group-dev"
#     propagate_at_launch = true
#   }
# }

