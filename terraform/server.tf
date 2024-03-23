resource "hcloud_server" "web" {
  name        = local.service
  image       = local.image
  server_type = local.server_type
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.default.id]
  labels = {
    type = "web"
  }
  user_data = file("user_data.yml")
}
