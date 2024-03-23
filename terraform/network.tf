resource "hcloud_network" "hc_private" {
  name     = "hc_private"
  ip_range = var.ip_range
}

resource "hcloud_server_network" "web_network" {
  server_id = hcloud_server.web.id
  subnet_id = hcloud_network_subnet.hc_private_subnet.id
}

resource "hcloud_network_subnet" "hc_private_subnet" {
  network_id   = hcloud_network.hc_private.id
  type         = "cloud"
  network_zone = var.network_zone
  ip_range     = var.ip_range
}

resource "hcloud_load_balancer" "web_lb" {
  name               = "web_lb"
  load_balancer_type = "lb11"
  location           = var.location
  labels = {
    type = "web"
  }

  target {
    type = "server"
    server_id = hcloud_server.web.id
  }
  algorithm {
    type = "round_robin"
  }
}

resource "hcloud_load_balancer_service" "web_lb_service" {
  load_balancer_id = hcloud_load_balancer.web_lb.id
  protocol         = var.http_protocol
  listen_port      = var.http_port
  destination_port = var.http_port

  health_check {
    protocol = var.http_protocol
    port     = var.http_port
    interval = "10"
    timeout  = "10"
    http {
      path         = "/"
      status_codes = ["2??", "3??"]
    }
  }
}

resource "hcloud_load_balancer_network" "web_network" {
  load_balancer_id        = hcloud_load_balancer.web_lb.id
  subnet_id               = hcloud_network_subnet.hc_private_subnet.id
  enable_public_interface = "true"
}

