resource "libvirt_volume" "bootstrap_vol" {
    name = "bootstrap.qcow2"
    base_volume_id = var.os.image
    size = var.master.disk * 1024 * 1024 * 1024
}

resource "libvirt_ignition" "ign_bootstrap" {
  name = "bootstrap.ign"
  content = "/var/lib/libvirt/images/bootstrap.ign"
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
    network_interface {
      network_id  = libvirt_network.k8s_network.id
      hostname    = "bootstrap.k8s.lab.local"
      addresses   = ["192.168.44.8"]
      mac         = "52:54:00:44:44:08"
    }
    coreos_ignition = libvirt_ignition.ign_bootstrap.id
    qemu_agent = true
    running = true
}
