variable "hcloud_token" {
  type      = string
  sensitive = true
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
