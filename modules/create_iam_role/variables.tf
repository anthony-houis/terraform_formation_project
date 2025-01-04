variable "role_name" {
  description = "The name of the IAM role"
}

variable "service" {
  description = "The service that will assume the role"
}

variable "Name" {
  default     = "formation"
}