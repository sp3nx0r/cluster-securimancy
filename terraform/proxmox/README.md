Reference: https://medium.com/@ssnetanel/build-a-kubernetes-cluster-using-k3s-on-proxmox-via-ansible-and-terraform-c97c7974d4a5

## QM Setup
This must be done manually outside of proxmox to prepare the template image

```
sudo apt-get install libguestfs-tools
wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img
virt-customize -a focal-server-cloudimg-amd64.img --install qemu-guest-agent
scp focal-server-cloudimg-amd64.img Proxmox_username@Proxmox_host:/path_on_Proxmox/focal-server-cloudimg-amd64.img
```

Now on Proxmox, execute qemu-config.sh

## Terraform Setup

1. The proxmox provider needs to connect via API and is expecting a username/password combo. Set these via the the `secret.sops.yaml` definition.

2. Check quantities of master/workers is correct in `vars.tf`

3. `terraform init / plan / apply` - note this will time out because the qemu agents aren't installed, but will be success
