TERMUX_PKG_HOMEPAGE=https://cisco.github.io/ChezScheme
TERMUX_PKG_DESCRIPTION="Chez Scheme is both a programming language, an implementation, and a superset of R6RS"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Komo @mbekkomo"
TERMUX_PKG_VERSION=10.1.0
TERMUX_PKG_SRCURL=https://github.com/cisco/ChezScheme/releases/download/v${TERMUX_PKG_VERSION}/csv${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9181a6c8c4ab5e5d32d879ff159d335a50d4f8b388611ae22a263e932c35398b
TERMUX_PKG_DEPENDS="libiconv, liblz4, ncurses, zlib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_host_build() {
	# Copied from chez-scheme APKBUILD
	case ${TERMUX_ARCH} in
	x86_64) CHEZ_HOST=ta6le ;;
	aarch64) CHEZ_HOST=tarm64le ;;
	i686) CHEZ_HOST=ti3le ;;
	arm) CHEZ_HOST=tarm32le ;;
	esac
	export CHEZ_HOST

	cd "${TERMUX_PKG_SRCDIR}" || termux_error_exit "Error: failed to perform host build for chez-scheme"
	./configure CC=gcc
	make -j "${TERMUX_PKG_MAKE_PROCESSES}"
	make -j "${TERMUX_PKG_MAKE_PROCESSES}" bootquick XM="${CHEZ_HOST}"
}

termux_step_configure() {
	./configure --cross --force \
		--prefix="${TERMUX_PREFIX}" \
		--installman="${TERMUX_PREFIX}/share/man" \
		--nogzip-man-pages \
		--machine="${CHEZ_HOST}" \
		--installschemename=chez \
		--installscriptname=chez-script \
		--installpetitename=chez-petite \
		--disable-x11 \
		ZLIB="-lz" LZ4="-llz4" LIBS="-liconv" \
		CC_FOR_BUILD=gcc
}

termux_step_post_make_install() {
	# remove hardlinks and replace with symlinks instead
	local chezlib="${TERMUX_PREFIX}/lib/csv${TERMUX_PKG_VERSION}"
	local bootlib="$chezlib/${CHEZ_HOST}"

	rm -f "$bootlib/chez.boot" "$bootlib/chez-script.boot" "$bootlib/chez-petite.boot"

	ln -s "$bootlib/"{scheme,chez}.boot
	ln -s "$bootlib/"{scheme,chez-script}.boot
	ln -s "$bootlib/"{petite,chez-petite}.boot
}
