# Variables
variable "docker_image_name" {
  description = "docker image"
  type = string
}

variable "docker_image_tag" {
  description = "docker image tag"
  type = string
}

variable "db_hostname" {
  description = "database hostname"
  type = string
}

variable "db_password_64encoded" {
  description = "database password encoded in base64"
  type = string
}
