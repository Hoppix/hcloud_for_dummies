resource "hcloud_firewall" "deny_all" {
    name   = "deny_all"
}

resource "hcloud_firewall" "allow_udp_in" {
    name   = "allow_rules"

    rule {
        direction       = "in"
        protocol        = "udp"
        port            = local.port
        source_ips      = [
            "0.0.0.0/0",
            "::/0",
        ]
        destination_ips = [
            format("%s/32", hcloud_server.server.ipv4_address)
        ]
    }
}
resource "hcloud_firewall" "allow_udp_out" {
    name   = "allow_rules"

    rule {
        direction       = "out"
        protocol        = "udp"
    }
}

resource "hcloud_firewall_attachment" "deny_all_att" {
    firewall_id = hcloud_firewall.deny_all.id
    server_ids  = [hcloud_server.server.id]
}

resource "hcloud_firewall_attachment" "allow_udp_in" {
    firewall_id = hcloud_firewall.allow_udp_in
    server_ids  = [hcloud_server.server.id]
}
resource "hcloud_firewall_attachment" "allow_udp_out" {
    firewall_id = hcloud_firewall.allow_udp_out.id
    server_ids  = [hcloud_server.test_server.id]
}