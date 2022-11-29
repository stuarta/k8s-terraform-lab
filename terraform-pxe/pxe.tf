resource "local_file" "pxe_bootstrap" {
  content = templatefile("pxeboot.tmpl", {
    "ignition_file" = "bootstrap.ign",
    "kernel" = var.coreos.kernel,
    "initrd" = var.coreos.initrd,
    "rootfs" = var.coreos.rootfs,
    "pxeserver" = var.pxe.server
  })
  filename = "/var/www/html/pxelinux.cfg/01-${replace(libvirt_domain.bootstrap.network_interface[0].mac, ":", "-")}"
}

resource "local_file" "pxe_master" {
  count = var.master.count
  content = templatefile("pxeboot.tmpl", {
    "ignition_file" = "master.ign",
    "kernel" = var.coreos.kernel,
    "initrd" = var.coreos.initrd,
    "rootfs" = var.coreos.rootfs,
    "pxeserver" = var.pxe.server
  })
  filename = "/var/www/html/pxelinux.cfg/01-${replace(libvirt_domain.master[count.index].network_interface[0].mac, ":", "-")}"
}

resource "local_file" "pxe_worker" {
  count = var.worker.count
  content = templatefile("pxeboot.tmpl", {
    "ignition_file" = "worker.ign",
    "kernel" = var.coreos.kernel,
    "initrd" = var.coreos.initrd,
    "rootfs" = var.coreos.rootfs,
    "pxeserver" = var.pxe.server
  })
  filename = "/var/www/html/pxelinux.cfg/01-${replace(libvirt_domain.worker[count.index].network_interface[0].mac, ":", "-")}"
}
