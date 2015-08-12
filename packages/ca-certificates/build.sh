TERMUX_PKG_HOMEPAGE=http://curl.haxx.se/docs/caextract.html
TERMUX_PKG_DESCRIPTION="Common CA certificates"
TERMUX_PKG_VERSION=20150427
TERMUX_PKG_BUILD_REVISION=1

termux_step_make_install () {
	CERTFILE=$TERMUX_PKG_TMPDIR/cert.pem
	curl -o $CERTFILE https://raw.githubusercontent.com/bagder/ca-bundle/master/ca-bundle.crt
	if grep -q 'SHA1: ed3c0bbfb7912bcc00cd2033b0cb85c98d10559c' $CERTFILE; then
		CERT_DIR=$TERMUX_PREFIX/etc/tls
		mkdir -p $CERT_DIR
		mv $CERTFILE $CERT_DIR/cert.pem
	else
		echo "Have https://raw.githubusercontent.com/bagder/ca-bundle/master/ca-bundle.crt been updated?"
		exit 1
	fi
}
