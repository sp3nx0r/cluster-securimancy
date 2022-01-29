https://github.com/jet/kube-webhook-certgen

./kube-webhook-certgen create --namespace imageswap-system --cert-name cert.pem --key-name key.pem --secret-name imageswap-tls-pregen --host "imageswap.imageswap-system.svc,imageswap.imageswap-system.svc.cluster.local" --kubeconfig ./provision/kubeconfig
