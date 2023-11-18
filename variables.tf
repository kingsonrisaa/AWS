variable "vpc-cidr" {
  description = "CIDR VPC" 
}

variable "cidr-subnet-wordpress-public" {
  description = "CIDR Subnet Wordpress Public"
}

variable "az-wordpress-public" {
  description = "AZ Subnet Wordpress Public"
}

variable "ami-id" {
  description = "AMI ID"
}

variable "instance-wordpress-type" {
  description = "instance type wordpress"
}