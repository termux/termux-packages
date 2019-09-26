#!/bin/bash

set -e
shopt -s nullglob

CA_CERT_BUNDLE=@TERMUX_PREFIX@/etc/tls/cert.pem
ORIG_CA_CERT_BUNDLE=@TERMUX_PREFIX@/etc/tls/cert.orig.pem
USER_CA_CERT_DIR=@TERMUX_PREFIX@/etc/tls/user-certs.d

echo "Generating CA certificate bundle..."

cat "$ORIG_CA_CERT_BUNDLE" > "$CA_CERT_BUNDLE"
mkdir -p "$USER_CA_CERT_DIR"
for user_cert in "$USER_CA_CERT_DIR"/*.pem; do
	echo "Adding $user_cert to CA bundle..."

	# Certificate name.
	echo >> "$CA_CERT_BUNDLE"
	echo "$(basename "$user_cert")" >> "$CA_CERT_BUNDLE"
	for _ in $(seq 1 $(echo -n "$(basename "$user_cert")" | wc -c)); do
		echo -n "="
	done >> "$CA_CERT_BUNDLE"
	echo >> "$CA_CERT_BUNDLE"

	# Certificate data.
	cat "$user_cert" >> "$CA_CERT_BUNDLE"
done
