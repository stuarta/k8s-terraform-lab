variable "os" {
    type = object({
        image   = string
    })
    default = {
      image = "/var/lib/libvirt/images/fedora-coreos-35.20220410.3.1-qemu.x86_64.qcow2"
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