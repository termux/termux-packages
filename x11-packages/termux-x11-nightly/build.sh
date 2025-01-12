TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-x11
TERMUX_PKG_DESCRIPTION="Termux X11 add-on."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Twaik Yont @twaik"
TERMUX_PKG_VERSION=1.03.01
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/termux/termux-x11/archive/efb2d97a46adf1657bacf395c38166a648260066.tar.gz
TERMUX_PKG_SHA256=49f635b0aa731b72ad5f5fb78f770d47bc86eeab37b80a2e7a31e93e77e183b3
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="xkeyboard-config"
TERMUX_PKG_BREAKS="termux-x11"
TERMUX_PKG_REPLACES="termux-x11"
TERMUX_PKG_PROVIDES="termux-x11"

termux_step_make() {
	:
}

termux_step_make_install() {
	# Downloading full JDK to compile 7kb apk seems excessive, let's download a prebuilt.
	local LOADER_URL="https://github.com/termux/termux-x11/releases/download/nightly/termux-x11-nightly-1.03.01-0-any.pkg.tar.xz"
	install -t $TERMUX_PREFIX/bin -m 755 termux-x11 termux-x11-preference
	mkdir -p $TERMUX_PREFIX/libexec/termux-x11
	wget -qO- $LOADER_URL | tar -OJxf - --wildcards "*loader.apk" > $TERMUX_PREFIX/libexec/termux-x11/loader.apk
}

termux_step_create_debscripts() {
	cat <<- EOF > postinst
		#!${TERMUX_PREFIX}/bin/sh
		chmod -w $TERMUX_PREFIX/libexec/termux-x11/loader.apk
	EOF

	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ]; then
		echo "post_install" > postupg
	fi
}
