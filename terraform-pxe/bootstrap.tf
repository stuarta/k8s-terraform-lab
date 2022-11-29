resource "libvirt_volume" "bootstrap_vol" {
    name = "bootstrap.qcow2"
    size = var.master.disk * 1024 * 1024 * 1024
}

resource "libvirt_domain" "bootstrap" {
    name    = "bootstrap"
    vcpu    = var.master.vcpu
    memory  = var.master.memory
    cpu {
      mode = "host-passthrough"
    }
    disk {
      volume_id = libvirt_volume.bootstrap_vol.id
      scsi      = true
    }
    boot_device {
      dev = [ "hd", "network"]
    }
    network_interface {
      network_id  = libvirt_network.k8s_network.id
      hostname    = "bootstrap.${var.cluster.name}.${var.cluster.domain}"
      addresses   = ["192.168.44.8"]
      mac         = "52:54:00:44:44:08"
    }
    qemu_agent = true
    running = true
}
