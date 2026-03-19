variable "cidr" {
  default = "10.0.0.0/16"
}

variable "subcidr1" {
  default = "10.0.1.0/24"
}

variable "subcidr2" {
  default = "10.0.2.0/24"
}

variable "availability_zone_one" {
  default = "us-east-1a"
}

variable "availability_zone_two" {
  default = "us-east-1b"
}

variable "ec2_instance_type" {
  default = "t3.micro"
}

variable "ec2_instance_ami" {
  default = "ami-02dfbd4ff395f2a1b"
}

variable "key_name" {
  default = "ansible-key"
}