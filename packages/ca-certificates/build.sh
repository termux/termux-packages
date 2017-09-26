TERMUX_PKG_HOMEPAGE=https://curl.haxx.se/docs/caextract.html
TERMUX_PKG_DESCRIPTION="Common CA certificates"
TERMUX_PKG_VERSION=20170920
TERMUX_PKG_PLATFORM_INDEPENDENT=yes

termux_step_make_install () {
	local CERTDIR=$TERMUX_PREFIX/etc/tls
	local CERTFILE=$CERTDIR/cert.pem
	# If the checksum has changed, it may be time to update the package version.
	local CERTFILE_SHA256=435ac8e816f5c10eaaf228d618445811c16a5e842e461cb087642b6265a36856

	mkdir -p $CERTDIR

	termux_download https://curl.haxx.se/ca/cacert.pem \
		$CERTFILE \
		$CERTFILE_SHA256
	touch $CERTFILE

	# Build java keystore which is split out into a ca-certificates-java subpackage:
	local KEYUTIL_JAR=$TERMUX_PKG_CACHEDIR/keyutil-0.4.0.jar
	termux_download \
		https://github.com/use-sparingly/keyutil/releases/download/0.4.0/keyutil-0.4.0.jar \
		$KEYUTIL_JAR \
		18f1d2c82839d84949b1ad015343c509e81ef678c24db6112acc6c0761314610

	local JAVA_KEYSTORE_DIR=$PREFIX/lib/jvm/openjdk-9/lib/security
	mkdir -p $JAVA_KEYSTORE_DIR

	java -jar $KEYUTIL_JAR \
		--import \
		--new-keystore $JAVA_KEYSTORE_DIR/jssecacerts \
		--password changeit \
		--force-new-overwrite \
		--import-pem-file $CERTFILE
}
