#! /bin/bash

# reference blog: https://medium.com/@ssnetanel/build-a-kubernetes-cluster-using-k3s-on-proxmox-via-ansible-and-terraform-c97c7974d4a5
# reference script: https://gist.github.com/ilude/457f2ef2e59d2bff8bb88b976464bb91
# This script prepares the cloud-init image used in subsequent terraform steps

# change this if default storage is not used
CLUSTER_STORAGE="local-lvm"

wget -nc https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img

# Create a VM
qm create 9000 --name ubuntu-focal-templ --memory 4096 --machine q35 --bios ovmf --net0 virtio,bridge=vmbr0

# Import the downloaded disk to local-lvm storage
qm importdisk 9000 focal-server-cloudimg-amd64.img $CLUSTER_STORAGE

# finally attach the new disk to the VM as scsi drive
qm set 9000 --scsihw virtio-scsi-pci --scsi0 $CLUSTER_STORAGE:vm-9000-disk-0
# add cloud-init image to the VM
qm set 9000 --ide2 $CLUSTER_STORAGE:cloudinit
# set the VM to boot from the cloud-init disk:
qm set 9000 --boot c --bootdisk scsi0
qm set 9000 --serial0 socket --vga serial0
# Using a dhcp server on vmbr1 or use static IP
qm set 9000 --ipconfig0 ip=dhcp
#qm set 9000 --ipconfig0 ip=10.10.10.222/24,gw=10.10.10.1

# The initial disk is only 2GB, thus we make it larger
qm resize 9000 scsi0 +30G

# user authentication for 'ubuntu' user (optional password)
tail -n 1 ~/.ssh/authorized_keys > /tmp/ssh_key_from_ansible
qm set 9000 --sshkey /tmp/ssh_key_from_ansible
#qm set 9000 --cipassword AweSomePassword

qm template 9000
