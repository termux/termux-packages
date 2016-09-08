TERMUX_PKG_HOMEPAGE=http://curl.haxx.se/docs/caextract.html
TERMUX_PKG_DESCRIPTION="Common CA certificates"
TERMUX_PKG_VERSION=20160907
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	local CERTDIR=$TERMUX_PREFIX/etc/tls
	local CERTFILE=$CERTDIR/cert.pem
	# If the checksum has changed, it may be time to update the package version..
	local CERTFILE_SHA256=e39faef9a13c44ddc75f7c0d0d6977fb2bc707ae1d08d47469b9c5ac8f260e40

	mkdir -p $CERTDIR

	termux_download https://raw.githubusercontent.com/bagder/ca-bundle/master/ca-bundle.crt \
		$CERTFILE \
		$CERTFILE_SHA256
}
