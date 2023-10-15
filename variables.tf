variable "access_key" {}
variable "secret_key" {}
variable "key_name" {}
variable "region" {}
variable "ami" {}
variable "vpc_name" {}
variable "subnet1_name" {} # local tf name
variable "subnet2_name" {} # local tf name
variable "pub_subnet1" {}  #az
variable "pub_subnet2" {}  #az
variable "instance_type" {}
variable "dep5_rte" {}
variable "sg_name" {}
variable "app_server" {}
variable "web_server" {}
variable "dep5_route_table" {}
variable "igw_name" {}
variable "vpc_cidr_block" {}
variable "subnet1_cidr_block" {}
variable "subnet2_cidr_block" {}
variable "route_table_cidr_block" {}