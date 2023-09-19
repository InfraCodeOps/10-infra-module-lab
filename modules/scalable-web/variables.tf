
# Complete these two variables


# Variable for the name of the application
# String type
# This surfaces in the web page UI
# See app.tf for how this is used
variable "app-name" {
# ...
}


# Variable for ec2 instance type
# default should be "t3.nano"
# contraint making sure it is t3.nano, t3.micro, or t3.small
variable "instance_type" {
# ...
}


# Leave the following as they are:

variable "region" {
  type = string
  default = "us-west-2"
  description = "Region where the resources will be created"
}

variable "num-replicas" {
  type = number
  default = 2
  description = "Number of replicas to create. Must be 2 or 3"
  validation {
    condition = var.num-replicas ==2 || var.num-replicas ==3
    error_message = "Number of replicas must be 2 or 3"
  }
}

# Variable deciding if the app is public or private
variable "associate_public_ip" {
  type = bool
  default = false
  description = "Associate public IP addresses with web app the instances? Default is false"
}
