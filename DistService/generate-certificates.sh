#!/bin/bash
FQDN=$1

# make directories to work from
mkdir -p certificates/{server,client,ca,tmp}

# Create your very own Root Certificate Authority
openssl genrsa \
  -out certificates/ca/self-signed-root-ca.key.pem \
  2048

# Self-sign your Root Certificate Authority
# Since this is private, the details can be as bogus as you like
openssl req \
  -x509 \
  -new \
  -nodes \
  -key certificates/ca/self-signed-root-ca.key.pem \
  -days 1024 \
  -out certificates/ca/self-signed-root-ca.crt.pem \
  -subj "/C=SE/ST=Sweden/L=Stockholm/O=APPoteket Dev/CN=APPoteket.Dev.apoteket.se"

# Create a Device Certificate for each domain,
# such as example.com, *.example.com, awesome.example.com
# NOTE: You MUST match CN to the domain name or ip address you want to use
openssl genrsa \
  -out certificates/server/self-signed-server.key.pem \
  2048

# Create a request from your Device, which your Root CA will sign
openssl req -new \
  -key certificates/server/self-signed-server.key.pem \
  -out certificates/tmp/self-signed-server.csr.pem \
  -subj "/C=SE/ST=Sweden/L=Stockholm/O=APPoteket Dev/CN=${FQDN}"

# Sign the request from Device with your Root CA
# -CAserial certificates/ca/self-signed-root-ca.srl
openssl x509 \
  -req -in certificates/tmp/self-signed-server.csr.pem \
  -CA certificates/ca/self-signed-root-ca.crt.pem \
  -CAkey certificates/ca/self-signed-root-ca.key.pem \
  -CAcreateserial \
  -out certificates/server/self-signed-server.crt.pem \
  -days 500

# Create a public key, for funzies
# see https://gist.github.com/coolaj86/f6f36efce2821dfb046d
openssl rsa \
  -in certificates/server/self-signed-server.key.pem \
  -pubout -out certificates/client/self-signed-server.pub

# Put things in their proper place
rsync -a certificates/ca/self-signed-root-ca.crt.pem certificates/server/
rsync -a certificates/ca/self-signed-root-ca.crt.pem certificates/client/
