variable "cluster" {
    type = object({
        name    = string
        domain  = string
    })
    default = {
        name    = "k8s"
        domain  = "lab.local"
    }
}

variable "coreos" {
    type = object({
        kernel  = string
        initrd  = string
        rootfs  = string
    })
    default = {
        kernel  = "fedora-coreos-35.20220116.2.0-live-kernel-x86_64"
        initrd  = "fedora-coreos-35.20220116.2.0-live-initramfs.x86_64.img"
        rootfs  = "fedora-coreos-35.20220116.2.0-live-rootfs.x86_64.img"
    }
}

variable "pxe" {
    type = object({
        server  = string
    })
    default = {
        server  = "192.168.44.1" // This also needs to be correct in bootp.xslt
    }
}

variable "master" {
    type = object({
        count   = number
        vcpu    = number
        memory  = number
        disk    = number
    })
    default = {
        count   = 3
        vcpu    = 4
        memory  = 16384
        disk    = 100   # in Gb
    }
}

variable "worker" {
    type = object({
        count   = number
        vcpu    = number
        memory  = number
        disk    = number
    })
    default = {
        count   = 2
        vcpu    = 2
        memory  = 8192
        disk    = 100   # in Gb
    }
}