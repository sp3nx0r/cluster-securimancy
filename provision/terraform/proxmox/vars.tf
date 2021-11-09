variable "username" {
  description = "The username for the proxmox user"
  type        = string
  sensitive = false
  default = ""

}
variable "password" {
  description = "The password for the proxmox user, set with .tfenv"
  type        = string
  sensitive = true
  default = ""
}

variable "proxmox-host" {
  description = "The IP for proxmox host"
  type        = string
  default = "192.168.5.10"
}

variable "pvt_key" {
  default = "~/.ssh/id_rsa"
}

variable "num_k3s_masters" {
 default = 1
}

variable "num_k3s_masters_mem" {
 default = "4096"
}

variable "num_k3s_nodes" {
 default = 3
}

variable "num_k3s_nodes_mem" {
 default = "4096"
}

variable "template_vm_name" {
 default = "ubuntu-focal-cloudinit-template"
}
