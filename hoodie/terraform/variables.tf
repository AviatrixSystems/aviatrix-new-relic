variable "prefix" {
    default = ""  #
}

variable "vpc_id" {
    default = ""
}

variable "subnet_id" {
    default = ""
}

variable "region" {
    default = "eu-west-1"
}
variable "access_key" {
    default = "" // blank to use system defaults
}
variable "secret_key" {
    default = "" // blank to use system defaults
}

variable "ami_id" {
    # default = "ami-092cce4a19b438926"
    default = "" // discover ubuntu
}

variable "ec2_type" {
    default = "t3.small"
}

variable "db_user" {
    default = "catalogue_user"
}

variable "db_pass" {
    default = ""  # random; but need to output one
}

