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
variable "s3_bucket" {
  default = "terraform-demo-sthree"
}
variable "ec2_instance_type" {
  default = "t3.micro"
}
variable "ec2_instance_ami" {
  default = "ami-068c0051b15cdb816"
}
variable "key_name"{
    default = "ansible-key"
}