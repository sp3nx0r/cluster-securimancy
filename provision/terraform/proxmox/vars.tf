
variable "proxmox-host" {
  description = "The IP for proxmox host"
  type        = string
  default     = "192.168.5.10"
}

variable "nameserver" {
  description = "The IP for gateway"
  type        = string
  default     = "192.168.5.1"
}

variable "pvt_key" {
  default = "~/.ssh/id_rsa"
}

variable "num_k3s_masters" {
  default = 3
}

variable "num_k3s_masters_mem" {
  default = "4096"
}

variable "num_k3s_masters_cores" {
  default = "2"
}

variable "num_k3s_nodes" {
  default = 3
}

variable "num_k3s_nodes_mem" {
  default = "6144"
}

variable "num_k3s_nodes_cores" {
  default = "2"
}

variable "template_vm_name" {
  default = "ubuntu-focal-templ"
}
