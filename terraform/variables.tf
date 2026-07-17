variable "aws_region" {
  description = "AWS Region"
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "EKS Cluster Name"
  default     = "devops-eks-cluster"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_1" {
  default = "10.0.1.0/24"
}

variable "public_subnet_2" {
  default = "10.0.2.0/24"
}

variable "private_subnet_1" {
  default = "10.0.3.0/24"
}

variable "private_subnet_2" {
  default = "10.0.4.0/24"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "desired_size" {
  default = 2
}

variable "min_size" {
  default = 2
}

variable "max_size" {
  default = 3
}