
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "Existing AWS EC2 key pair name"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "Your public IP in CIDR notation"
  type        = string
}

variable "allowed_jenkins_cidr" {
  description = "CIDR allowed to access Jenkins UI"
  type        = string
  default     = "0.0.0.0/0"
}
