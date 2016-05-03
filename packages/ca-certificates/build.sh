TERMUX_PKG_HOMEPAGE=http://curl.haxx.se/docs/caextract.html
TERMUX_PKG_DESCRIPTION="Common CA certificates"
TERMUX_PKG_VERSION=20160429
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	CERTFILE=$TERMUX_PKG_TMPDIR/cert.pem
	curl -o $CERTFILE https://raw.githubusercontent.com/bagder/ca-bundle/master/ca-bundle.crt
	if grep -q 'SHA1: 5df367cda83086392e1acdf22bfef00c48d5eba6' $CERTFILE; then
		CERT_DIR=$TERMUX_PREFIX/etc/tls
		mkdir -p $CERT_DIR
		mv $CERTFILE $CERT_DIR/cert.pem
	else
		echo "Have https://raw.githubusercontent.com/bagder/ca-bundle/master/ca-bundle.crt been updated?"
		exit 1
	fi
}
