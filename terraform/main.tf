resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr
  
   tags = {
    Name = "my_vpc"
  }
}
resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.subcidr1
  availability_zone = var.availability_zone_one
  map_public_ip_on_launch = true

  tags = {
    Name = "my_vpc_Subnet1"
  }
}
resource "aws_subnet" "my_subnet2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.subcidr2
  availability_zone = var.availability_zone_two
  map_public_ip_on_launch = true

  tags = {
    Name = "my_vpc_Subnet2"
  }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.my_vpc.id
    
    tags = {
        Name = "my_vpc_igw"
    }
}

resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.my_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }   
    tags = {
        Name = "my_vpc_rt"
    }
}
resource "aws_route_table_association" "rta1" {
    subnet_id = aws_subnet.my_subnet.id
    route_table_id = aws_route_table.rt.id
}
resource "aws_route_table_association" "rta2" {
    subnet_id = aws_subnet.my_subnet2.id
    route_table_id = aws_route_table.rt.id
}
resource "aws_security_group" "sg" {
    name        = "my_vpc_sg"
    description = "Allow SSH and HTTP"
    vpc_id      = aws_vpc.my_vpc.id

    ingress {
        description = "SSH access"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "HTTP access"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }   
    tags = {
        Name = "my_vpc_sg"
    }
}
resource "aws_alb" "alb" {
    name               = "my-vpc-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.sg.id]
    subnets            = [aws_subnet.my_subnet.id, aws_subnet.my_subnet2.id]
    
    
    tags = {
        Name = "my_vpc_alb"
    }
}
resource "aws_alb_target_group" "tg" {
    name     = "my-vpc-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = aws_vpc.my_vpc.id

    health_check {
        path = "/"
        port = "traffic-port"
    }

    tags = {
        Name = "my_vpc_tg"
    }
}
resource "aws_alb_listener" "listener" {
    load_balancer_arn = aws_alb.alb.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_alb_target_group.tg.arn
    }
}
resource "aws_launch_template" "lt" {
  name_prefix   = "my-launch-template"
  image_id      = var.ec2_instance_ami
  instance_type = var.ec2_instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.sg.id]
  }

  user_data = base64encode(file("userdata.sh"))
}
resource "aws_autoscaling_group" "asg" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = [
    aws_subnet.my_subnet.id,
    aws_subnet.my_subnet2.id
  ]

  target_group_arns = [aws_alb_target_group.tg.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "my-asg-instance"
    propagate_at_launch = true
  }
}
# Scaling Policy
resource "aws_autoscaling_policy" "cpu_policy" {
  name                   = "cpu-scaling"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }
}