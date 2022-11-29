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
    name = "${var.cluster.name}"
    mode = "route"
    domain = "${var.cluster.domain}"
    addresses = ["192.168.44.0/24"]
    autostart = "true"
    dns {
      enabled = true
    }
    xml {
      xslt = "${file("bootp.xslt")}"
    }
}

resource "libvirt_volume" "master_vol" {
    count = var.master.count
    name = "master-${count.index}.qcow2"
    size = var.master.disk * 1024 * 1024 * 1024
}

resource "libvirt_volume" "worker_vol" {
    count = var.worker.count
    name = "worker-${count.index}.qcow2"
    size = var.worker.disk * 1024 * 1024 * 1024
}

resource "libvirt_domain" "master" {
    count   = var.master.count
    name    = "k8s-master-${count.index}"
    vcpu    = var.master.vcpu
    memory  = var.master.memory
    cpu {
      mode = "host-passthrough"
    }
    disk {
      volume_id = libvirt_volume.master_vol[count.index].id
      scsi      = true
    }
    boot_device {
      dev = [ "hd", "network"]
    }
    network_interface {
      network_id  = libvirt_network.k8s_network.id
      hostname    = "master-${count.index}.${var.cluster.name}.${var.cluster.domain}"
      addresses   = ["192.168.44.2${count.index}"]
      mac         = "52:54:00:44:44:2${count.index}"
    }
    qemu_agent = true
    running = false
}

resource "libvirt_domain" "worker" {
    count   = var.worker.count
    name    = "k8s-worker-${count.index}"
    vcpu    = var.worker.vcpu
    memory  = var.worker.memory
    cpu {
      mode = "host-passthrough"
    }
    disk {
      volume_id = libvirt_volume.worker_vol[count.index].id
      scsi      = true
    }
    boot_device {
      dev = [ "hd", "network"]
    }
    network_interface {
      network_id  = libvirt_network.k8s_network.id
      hostname    = "worker-${count.index}.${var.cluster.name}.${var.cluster.domain}"
      addresses   = ["192.168.44.3${count.index}"]
      mac         = "52:54:00:44:44:3${count.index}"
    }
    qemu_agent = true
    running = false
}
