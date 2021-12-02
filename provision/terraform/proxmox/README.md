Reference: https://medium.com/@ssnetanel/build-a-kubernetes-cluster-using-k3s-on-proxmox-via-ansible-and-terraform-c97c7974d4a5

1. The proxmox provider needs to connect via API and is expecting a username/password combo. Set these via the variable `password` (likely through adding an env var TF_VAR_password)

2. Check quantities of master/workers is correct in `vars.tf`

3. `terraform init / plan / apply` - note this will time out because the qemu agents aren't installed, but will be success
