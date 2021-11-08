#! /bin/bash

wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img

# Create a VM
qm create 9000 --name ubuntu1804-templ --memory 2048 --net0 virtio,bridge=vmbr1

# Import the disk in qcow2 format (as unused disk) 
qm importdisk 9000 bionic-server-cloudimg-amd64.img local -format qcow2

# Attach the disk to the vm using VirtIO SCSI
qm set 9000 --scsihw virtio-scsi-pci --scsi0 /var/lib/vz/images/9000/vm-9000-disk-0.qcow2

# Important settings
qm set 9000 --ide2 local:cloudinit --boot c --bootdisk scsi0 --serial0 socket --vga serial0

# The initial disk is only 2GB, thus we make it larger
qm resize 9000 scsi0 +30G

# Using a  dhcp server on vmbr1 or use static IP
qm set 9000 --ipconfig0 ip=dhcp
#qm set 9000 --ipconfig0 ip=10.10.10.222/24,gw=10.10.10.1

# user authentication for 'ubuntu' user (optional password)
qm set 9000 --sshkey ~/.ssh/id_rsa.pub
#qm set 9000 --cipassword AweSomePassword

# check the cloud-init config
qm cloudinit dump 9000 user
