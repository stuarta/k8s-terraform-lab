terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
    uri = "qemu:///system"
}

resource "libvirt_network" "k8s_network" {
    name = "k8s"
    #mode = "route"
    domain = "lab.local"
    addresses = ["192.168.44.0/24"]
    autostart = "true"
    dns {
      enabled = true
    }
    xml {
      xslt = "${file("bootp.xslt")}"
    }
}
