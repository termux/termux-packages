TERMUX_PKG_HOMEPAGE=https://testssl.sh/
TERMUX_PKG_DESCRIPTION="Testing TLS/SSL encryption anywhere on any port."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.0.7
TERMUX_PKG_SRCURL=https://github.com/drwetter/testssl.sh/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c2beb3ae1fc1301ad845c7aa01c0a292c41b95747ef67f34601f21fb2da16145
TERMUX_PKG_DEPENDS="bash, ca-certificates, coreutils, gawk, procps, curl, socat, openssl-tool"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"

termux_step_configure() {
	sed -e 's#\${TESTSSL_INSTALL_DIR.*$#\${TESTSSL_INSTALL_DIR:-"%{_datadir}/%{name}}"#' \
	-e "s|OPENSSL=\"\"|OPENSSL=\"\$TERMUX_PREFIX/bin/openssl\"|g" -e "s|/etc/hosts|\$TERMUX_PREFIX/etc/hosts|g" \
	-e "s|TEMPDIR=\"\"|TEMPDIR=\"\$TERMUX_PREFIX/tmp\"|g" -e "s|tee /tmp/testssl|tee \$TERMUX_PREFIX/tmp/testssl|g" \
	-e 's#\${CA_BUNDLES_PATH.*$#\${CA_BUNDLES_PATH:-"%{_datadir}/%{name}}"#' -i testssl.sh
	sed -i '0,/.SH "COPYRIGHT"/s#testssl\\.sh#testssl#g' doc/testssl.1
}



termux_step_make_install() {
	install -Dm 755 testssl.sh "$TERMUX_PREFIX/bin/testssl"
	install -Dm 644 etc/* -t "$TERMUX_PREFIX/share/testssl/etc"
	install -Dm 644 Readme.md doc/testssl.1.md -t "$TERMUX_PREFIX/share/doc/testssl"
	install -Dm 644 doc/testssl.1 -t "$TERMUX_PREFIX/share/man/man1"
}
