# Default matcher group for machines
resource "matchbox_group" "default" {
  name    = "default"
  profile = matchbox_profile.coreos-install.name

  # no selector means all machines can be matched
  metadata = {
    ignition_endpoint  = "${var.matchbox_http_endpoint}/ignition"
    ssh_authorized_key = var.ssh_authorized_key
  }
}

# Match machines which have CoreOS Container Linux installed
resource "matchbox_group" "hardcore_1" {
  name    = "hardcore_1"
  profile = matchbox_profile.hardcore-install.name

  selector = {
    os = "installed"
  }

  metadata = {
    ssh_authorized_key = var.ssh_authorized_key
  }
}

# CoreOS-install profile
resource "matchbox_profile" "coreos-install" {
  name   = "coreos-install"
  kernel = "http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz"
  #kernel = "/assets/coreos_production_pxe.vmlinuz"

  initrd = [
    "http://stable.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz",
  #  "/assets/coreos_production_pxe_image.cpio.gz",
  ]

  args = [
    "initrd=coreos_production_pxe_image.cpio.gz",
    "coreos.config.url=${var.matchbox_http_endpoint}/ignition?uuid=$${uuid}&mac=$${mac:hexhyp}",
    "coreos.first_boot=yes",
    "console=tty0",
    "console=ttyS0",
  ]

  container_linux_config = file("./coreos-install.yaml.tmpl")
}

resource "matchbox_profile" "hardcore-install" {
  name   = "hardcore-install"

  args = [
    "coreos.config.url=${var.matchbox_http_endpoint}/ignition?uuid=$${uuid}&mac=$${mac:hexhyp}",
    "console=tty0",
    "console=ttyS0",
  ]

  container_linux_config = file("./hardcore.yaml.tmpl") 
}

