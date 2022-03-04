TERMUX_PKG_HOMEPAGE=https://curl.se/docs/caextract.html
TERMUX_PKG_DESCRIPTION="Common CA certificates"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_DATE=2022-02-01
TERMUX_PKG_VERSION=1:${_DATE//-/.}
TERMUX_PKG_SRCURL=https://curl.se/ca/cacert-${_DATE}.pem
TERMUX_PKG_SHA256=1d9195b76d2ea25c2b5ae9bee52d05075244d78fcd9c58ee0b6fac47d395a5eb
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	local CERTDIR=$TERMUX_PREFIX/etc/tls
	local CERTFILE=$CERTDIR/cert.pem

	mkdir -p $CERTDIR

	termux_download $TERMUX_PKG_SRCURL \
		$CERTFILE \
		$TERMUX_PKG_SHA256
	touch $CERTFILE

	# Build java keystore which is split out into a ca-certificates-java subpackage:
	local KEYUTIL_JAR=$TERMUX_PKG_CACHEDIR/keyutil-0.4.0.jar
	termux_download \
		https://github.com/use-sparingly/keyutil/releases/download/0.4.0/keyutil-0.4.0.jar \
		$KEYUTIL_JAR \
		18f1d2c82839d84949b1ad015343c509e81ef678c24db6112acc6c0761314610

	local JAVA_KEYSTORE_DIR=$TERMUX_PREFIX/opt/openjdk-17/lib/security
	mkdir -p $JAVA_KEYSTORE_DIR

	java -jar $KEYUTIL_JAR \
		--import \
		--new-keystore $JAVA_KEYSTORE_DIR/jssecacerts \
		--password changeit \
		--force-new-overwrite \
		--import-pem-file $CERTFILE
}
