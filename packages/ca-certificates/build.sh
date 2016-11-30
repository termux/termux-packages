TERMUX_PKG_HOMEPAGE=http://curl.haxx.se/docs/caextract.html
TERMUX_PKG_DESCRIPTION="Common CA certificates"
TERMUX_PKG_VERSION=20161128
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	local CERTDIR=$TERMUX_PREFIX/etc/tls
	local CERTFILE=$CERTDIR/cert.pem
	# If the checksum has changed, it may be time to update the package version.
	local CERTFILE_SHA256=7458091b8d536e216823ab0f749f7d51714a8c4d47d25ca610d41ef4b45483d5

	mkdir -p $CERTDIR

	termux_download https://raw.githubusercontent.com/bagder/ca-bundle/master/ca-bundle.crt \
		$CERTFILE \
		$CERTFILE_SHA256
}
