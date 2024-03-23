
locals {
  service = "default"
  server_type = "cx11"
  image = "ubuntu-22.04"

  user_data = templatefile("${path.module}/user_data.yml", {
    ssh_user = var.ssh_user
    ssh_public_key = var.ssh_public_key
  })
}
