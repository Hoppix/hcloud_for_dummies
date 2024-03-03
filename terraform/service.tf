resource "hcloud_server" "server" {
  name        = local.service
  server_type = local.server_type
  image       = local.image

  firewall_ids = [  ]

  network {
    network_id = hcloud_network.network.id

    ip        = "10.0.1.5"
    alias_ips = ["10.0.1.6"]
  }

  depends_on = [hcloud_network_subnet.subnet]
}

resource "hcloud_network" "network" {
  name     = local.service
  ip_range = "10.0.0.0/16"

}

resource "hcloud_network_subnet" "subnet" {
  type         = "cloud"
  network_id   = hcloud_network.network.id
  network_zone = local.region
  ip_range     = "10.0.0.0/24"
}

resource "hcloud_load_balancer" "lb" {
  name               = local.service
  load_balancer_type = "lb11"
  network_zone       = local.region
}

resource "hcloud_load_balancer_network" "lb_network" {
  load_balancer_id = hcloud_load_balancer.lb.id
  network_id       = hcloud_network.network.id
  ip               = "10.0.1.9"
}
