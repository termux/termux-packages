TERMUX_PKG_HOMEPAGE=https://github.com/MoonLite-Br/Cpy
TERMUX_PKG_DESCRIPTION="Python-syntax interpreter written in portable C"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@MoonLite-Br"
TERMUX_PKG_VERSION="1.11.0"
TERMUX_PKG_SRCURL=https://github.com/MoonLite-Br/Cpy/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2ebbc01682367ea56a9e060884258b6ce00b3e438f5ea03ccf0f418e17c873d9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	make CC="$CC" CFLAGS="$CFLAGS $CPPFLAGS" LDFLAGS="$LDFLAGS"
}

termux_step_make_install() {
	install -Dm700 bin/cpy "$TERMUX_PREFIX/bin/cpy"
	# AOT helper sources + wrapper (optional native codegen frontend)
	mkdir -p "$TERMUX_PREFIX/share/cpy/selfhost"
	cp -a selfhost/. "$TERMUX_PREFIX/share/cpy/selfhost/"
	cat > "$TERMUX_PREFIX/bin/aotc" <<-EOF
	#!${TERMUX_PREFIX}/bin/sh
	exec ${TERMUX_PREFIX}/bin/cpy ${TERMUX_PREFIX}/share/cpy/selfhost/aotc.cpy "\$@"
	EOF
	chmod 700 "$TERMUX_PREFIX/bin/aotc"
}
