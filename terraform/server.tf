resource "hcloud_server" "server" {
  name        = local.service
  image       = local.image
  server_type = local.server_type
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.key.id]
  labels = {
    type = var.service
  }
  user_data = file("user_data.yml")

  firewall_ids = [ hcloud_firewall.firewall_deny.id, hcloud_firewall.firewall_allow.id]
}

resource "hcloud_network" "hc_private" {
  name     = "hc_private"
  ip_range = var.ip_range
}

resource "hcloud_server_network" "service_network" {
  server_id = hcloud_server.server.id
  subnet_id = hcloud_network_subnet.hc_private_subnet.id
}

resource "hcloud_network_subnet" "hc_private_subnet" {
  network_id   = hcloud_network.hc_private.id
  type         = "cloud"
  network_zone = var.network_zone
  ip_range     = var.ip_range
}

resource "hcloud_ssh_key" "key" {
  name       = "${var.service}-key"
  public_key = var.ssh_public_key
}

resource "hcloud_firewall" "firewall_deny" {
  name = "${var.service}-deny"
}

resource "hcloud_firewall" "firewall_allow" {
  name = "${var.service}-allow"

  rule {
    direction  = "in"
    protocol   = "udp"
    port       = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
  rule {
    direction  = "out"
    protocol   = "udp"
    port       = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "80"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
  rule {
    direction  = "out"
    protocol   = "tcp"
    port       = "80"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

}
