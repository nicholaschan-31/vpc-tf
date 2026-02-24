variable "cidr" {
  type        = string
  description = "cidr value"
}

variable "name" {
  type        = string
  description = "for tag"
}

variable "environment" {
  type        = string
  description = "for tag"
}

variable "owner" {
  type        = string
  description = "for tag"
}

variable "cidr_block_public_subnet" {
  type        = string
  description = "cidr value for public subnet"
}

variable "cidr_block_private_subnet" {
  type        = string
  description = "cidr value for public subnet"
}

variable "availability_zone" {
  type = string
}

variable "cidr_block_public_subnet_2" {
  type        = string
  description = "second public subnet"
}

variable "availability_zone_2" {
  type = string
}

variable "security_group_id" {
  type = list(string)
}