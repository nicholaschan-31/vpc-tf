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