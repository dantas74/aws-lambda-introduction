variable "env" {
  type    = string
  default = "dev"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_profile" {
  type    = string
  default = "default"
}

variable "aws_account_id" {
  type    = string
  default = "0000000000000"
}

variable "service_name" {
  type    = string
  default = "todos"
}
