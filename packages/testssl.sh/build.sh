TERMUX_PKG_HOMEPAGE=https://testssl.sh/
TERMUX_PKG_DESCRIPTION="Testing TLS/SSL encryption anywhere on any port."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.2.5"
TERMUX_PKG_SRCURL="https://github.com/testssl/testssl.sh/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=23bb53d50ae093b89631e9fff547c087f632bf35f7a3d7dc78dd4ffff56cd779
TERMUX_PKG_DEPENDS="bash, ca-certificates, coreutils, curl, gawk, openssl-tool, procps, resolv-conf, socat"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_CONFFILES="
etc/testssl/Apple.pem
etc/testssl/ca_hashes.txt
etc/testssl/cipher-mapping.txt
etc/testssl/client-simulation.txt
etc/testssl/client-simulation.wiresharked.md
etc/testssl/client-simulation.wiresharked.txt
etc/testssl/common-primes.txt
etc/testssl/curves.txt
etc/testssl/Java.pem
etc/testssl/Linux.pem
etc/testssl/Microsoft.pem
etc/testssl/Mozilla.pem
etc/testssl/openssl.cnf
etc/testssl/README.md
etc/testssl/tls_data.txt
"

termux_step_make_install() {
	install -Dm 755 -t "$TERMUX_PREFIX/bin" testssl.sh
	ln -sfr "$TERMUX_PREFIX/bin/testssl.sh" "$TERMUX_PREFIX/bin/testssl"
	install -Dm 644 -t "$TERMUX_PREFIX/etc/testssl" etc/*
	install -Dm 644 -t "$TERMUX_PREFIX/share/doc/testssl" Readme.md doc/testssl.1.md
	install -Dm 644 doc/testssl.1 "$TERMUX_PREFIX/share/man/man1/testssl.sh.1"
	ln -sfr "$TERMUX_PREFIX/share/man/man1/testssl.sh.1" "$TERMUX_PREFIX/share/man/man1/testssl.1"
}
