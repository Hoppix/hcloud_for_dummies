variable "hcloud_token" {
  type      = string
  sensitive = true
}

variable "service" {
  type = string
  default = "default"
}

variable "ssh_user" {
  type = string
  default = "default"
}

variable "ssh_public_key" {
  type = string
}

variable "location" {
  default = "nbg1"
}

variable "network_zone" {
  default = "eu-central"
}

variable "http_protocol" {
  default = "http"
}

variable "http_port" {
  default = "80"
}

variable "ip_range" {
  default = "10.0.1.0/24"
}
