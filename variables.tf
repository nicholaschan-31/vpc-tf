variable "cidr" {
  type        = string
  description = "cidr value"
}

variable "name" {
  type        = string
  description = "for tag"
}


variable "public_subnet" {
  type = list(object({
    cidr = string
    az   = string
  }))

  description = "public subnet list"
}

variable "private_subnet" {
  type = list(object({
    cidr = string
    az   = string
  }))

  description = "private subnet list"
}

variable "security_group_id" {
  type = list(string)
}

variable "endpoint_service_name" {
  type = list(string)
}