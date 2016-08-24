TERMUX_PKG_HOMEPAGE=http://curl.haxx.se/docs/caextract.html
TERMUX_PKG_DESCRIPTION="Common CA certificates"
TERMUX_PKG_VERSION=20160429
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	local CERTDIR=$TERMUX_PREFIX/etc/tls
	local CERTFILE=$CERTDIR/cert.pem
	# If the checksum has changed, it may be time to update the package version..
	local CERTFILE_SHA256=40f7c492be077f486df440b2497d2f68ae796619c57c1d32b82db18db853fb15

	mkdir -p $CERTDIR

	termux_download https://raw.githubusercontent.com/bagder/ca-bundle/master/ca-bundle.crt \
		$CERTFILE \
		$CERTFILE_SHA256
}
