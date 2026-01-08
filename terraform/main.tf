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
resource "aws_s3_bucket" "s3" {
    bucket = var.s3_bucket
}
resource "aws_instance" "webserver1" {
  ami           = var.ec2_instance_ami
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name               = var.key_name
  user_data              = file("userdata.sh")
    tags = {
        Name = "my_vpc_server1"
    }
}
resource "aws_instance" "webserver2" {
  ami           = var.ec2_instance_ami
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.my_subnet2.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name               = var.key_name
  user_data              = file("userdata.sh")
    tags = {
        Name = "my_vpc_server2"
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
resource "aws_alb_target_group_attachment" "attach1" {
    target_group_arn = aws_alb_target_group.tg.arn
    target_id        = aws_instance.webserver1.id
    port             = 80
}
resource "aws_alb_target_group_attachment" "attach2" {
    target_group_arn = aws_alb_target_group.tg.arn
    target_id        = aws_instance.webserver2.id
    port             = 80
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
#create Ansible inventory file
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory.ini"
  content  = templatefile("${path.module}/../ansible/inventory.ini.tpl", {
    web1_ip = aws_instance.webserver1.public_ip
    web2_ip = aws_instance.webserver2.public_ip
  })
}
