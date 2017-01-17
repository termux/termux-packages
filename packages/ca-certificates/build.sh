TERMUX_PKG_HOMEPAGE=http://curl.haxx.se/docs/caextract.html
TERMUX_PKG_DESCRIPTION="Common CA certificates"
TERMUX_PKG_VERSION=20170117
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	local CERTDIR=$TERMUX_PREFIX/etc/tls
	local CERTFILE=$CERTDIR/cert.pem
	# If the checksum has changed, it may be time to update the package version.
	local CERTFILE_SHA256=031761615fd48ca422bb81629db2b43e4401cf00b4eea259e5b8bd3791f5224a

	mkdir -p $CERTDIR

	termux_download https://raw.githubusercontent.com/bagder/ca-bundle/master/ca-bundle.crt \
		$CERTFILE \
		$CERTFILE_SHA256
}
