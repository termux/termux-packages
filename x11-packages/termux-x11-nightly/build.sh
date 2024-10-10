TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-x11
TERMUX_PKG_DESCRIPTION="Termux X11 add-on application. Still in early development."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Twaik Yont @twaik"
TERMUX_PKG_VERSION=1.03.01
TERMUX_PKG_SRCURL=https://github.com/termux/termux-x11/archive/f20fbbd6996653d2e03dbc7e3932508a88aaa15c.tar.gz
TERMUX_PKG_SHA256=d1111104a3f3946c55d403117916e4a2281454cf200188a69bde6df0ad2e82ec
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="xkeyboard-config"
TERMUX_PKG_BREAKS="termux-x11"
TERMUX_PKG_REPLACES="termux-x11"

termux_step_make() {
	:
}

termux_step_make_install() {
	# Downloading full JDK to compile 7kb apk seems excessive, let's download a prebuilt.
	local LOADER_URL="https://github.com/termux/termux-x11/releases/download/nightly/termux-x11-nightly-1.03.01-0-any.pkg.tar.xz"
	install -t $TERMUX_PREFIX/bin -m 755 termux-x11 termux-x11-preference
	wget -qO- $LOADER_URL | tar -OJxf - --wildcards "*loader.apk" > $TERMUX_PREFIX/libexec/termux-x11/loader.apk
}

termux_step_create_debscripts() {
	cat <<- EOF > postinst
		#!${TERMUX_PREFIX}/bin/sh
		chmod -w $TERMUX_PREFIX/libexec/termux-x11/loader.apk
	EOF
}
