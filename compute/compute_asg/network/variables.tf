variable "vpc_cidr" {
  type        = string
  description = "CIDR for vpc"
}

variable "enable_dns" {
  type        = bool
  description = "Whether to enable dns on public ips"
}

variable "app_name" {
  type        = string
  description = "Name of application being serverd by this auto scaling group"
}

variable "subnet_cidr" {
  description = "List of cidr blocks for public subnets."
  type        = list(string)
}

variable "av_zone" {
  description = "List of availability zones."
  type        = list(string)
}

variable "gateway_cidr" {
  type        = string
  description = "CIDR for indernet gateway."

  validation {
    condition = contains(["0.0.0.0/0"], var.gateway_cidr)
    error_message = "Gateway cidr must be 0.0.0.0/0"
  }
}

variable "protocol" {
  type        = string
  description = "Network protocol for security groups."
}

variable "sg_rule" {
  description = "Secutity group rules for security groups"
  type = list(object({
    port            = number
    protocol        = string
    cidr_blocks      = optional(list(string))
    security_groups = optional(list(string))
  }))

  default = [
    {
      port       = 22
      protocol   = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },

    {
      port       = 80
      protocol   = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },

    {
      port       = 443
      protocol   = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
