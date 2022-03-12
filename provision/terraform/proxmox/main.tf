terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">=2.8.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.6.3"
    }
  }
}
data "sops_file" "proxmox_secrets" {
  source_file = "secret.sops.yaml"
}
provider "proxmox" {
  pm_api_url      = "https://${var.proxmox-host}:8006/api2/json"
  pm_user         = data.sops_file.proxmox_secrets.data["user"]
  pm_password     = data.sops_file.proxmox_secrets.data["password"]
  pm_tls_insecure = "true"
  pm_parallel     = 10
}

resource "proxmox_vm_qemu" "proxmox_vm_master" {
  count       = var.num_k3s_masters
  name        = "k3s-master-${count.index}"
  target_node = "pve"
  clone       = var.template_vm_name
  os_type     = "cloud-init"
  agent       = 1
  memory      = var.num_k3s_masters_mem
  cores       = var.num_k3s_master_cores

  ipconfig0  = "ip=192.168.5.8${count.index}/24,gw=${var.nameserver}"
  nameserver = var.nameserver
}

resource "proxmox_vm_qemu" "proxmox_vm_workers" {
  count       = var.num_k3s_nodes
  name        = "k3s-worker-${count.index}"
  target_node = "pve"
  clone       = var.template_vm_name
  os_type     = "cloud-init"
  agent       = 1
  memory      = var.num_k3s_nodes_mem
  cores       = var.num_k3s_nodes_cores

  ipconfig0  = "ip=192.168.5.9${count.index}/24,gw=${var.nameserver}"
  nameserver = var.nameserver
}

data "template_file" "k8s" {
  template = file("./templates/k8s.tpl")
  vars = {
    k3s_master_ip = "${join("\n", [for instance in proxmox_vm_qemu.proxmox_vm_master : join("", [instance.default_ipv4_address, " ansible_ssh_private_key_file=", var.pvt_key])])}"
    k3s_node_ip   = "${join("\n", [for instance in proxmox_vm_qemu.proxmox_vm_workers : join("", [instance.default_ipv4_address, " ansible_ssh_private_key_file=", var.pvt_key])])}"
  }
}

# resource "local_file" "k8s_file" {
#   content  = data.template_file.k8s.rendered
#   filename = "../inventory/my-cluster/hosts.ini"
# }

output "Master-IPS" {
  value = ["${proxmox_vm_qemu.proxmox_vm_master.*.default_ipv4_address}"]
}
output "worker-IPS" {
  value = ["${proxmox_vm_qemu.proxmox_vm_workers.*.default_ipv4_address}"]
}
