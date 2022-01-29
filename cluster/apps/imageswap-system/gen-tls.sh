#!/bin/bash
# https://pretired.dazwilkin.com/posts/210108/

ca="imageswap-ca"
service="imageswap"
namespace="imageswap-system"

tmpdir=$(mktemp -d)
echo "creating certs in tmpdir ${tmpdir} "

openssl req -nodes -new -x509 -keyout ${tmpdir}/ca.key -out ${tmpdir}/ca.crt -subj "/CN=Admission Controller Webhook CA" -days 365

kubectl -n ${namespace} create secret tls ${ca} --cert "${tmpdir}/ca.crt" --key "${tmpdir}/ca.key"

# Create an issuer for our webhook
echo "
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: ${ca}
  namespace: ${namespace}
spec:
  ca:
    secretName: ${ca}
" | kubectl apply --filename=-

echo "
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: ${service}
  namespace: ${namespace}
spec:
  # Output
  secretName: ${service}-tls-cert-manager
  duration: 8760h
  renewBefore: 720h
  subject:
  # commonName: ${ENDPOINT}
  isCA: false
  privateKey:
    algorithm: RSA
    encoding: PKCS1
    size: 2048
  usages:
    - server auth
  dnsNames:
  - ${service}.${namespace}.svc
  - ${service}.${namespace}.svc.cluster.local
  # ipAddresses:
  # - ${ENDPOINT}
  issuerRef:
    name: ${ca}
    kind: Issuer
    group: cert-manager.io
" | kubectl apply --filename=-

echo "Waiting for cert-manager to issue its cert..."
sleep 5

CABUNDLE=$(\
  kubectl get secret/${service}-tls-cert-manager \
  --namespace=${namespace} \
  --output=jsonpath="{.data.ca\.crt}") && echo ${CABUNDLE}

rm -rf "${tmpdir}"
