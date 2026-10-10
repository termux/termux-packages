TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-x11
TERMUX_PKG_DESCRIPTION="Termux X11 add-on."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Twaik Yont @twaik"
TERMUX_PKG_VERSION="1.03.01"
TERMUX_PKG_REVISION=6
# Downloading full JDK to compile 7kb apk seems excessive, let's download a prebuilt.
TERMUX_PKG_SRCURL=https://github.com/termux/termux-x11/releases/download/nightly/termux-x11-nightly-1.03.01-0-any.pkg.tar.xz
TERMUX_PKG_SHA256=SKIP_CHECKSUM
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="xkeyboard-config"
# We provide a termux-x11-xfce4 service script, so let's suggest xfce4
TERMUX_PKG_SUGGESTS="xfce4"
TERMUX_PKG_BREAKS="termux-x11"
TERMUX_PKG_REPLACES="termux-x11"
TERMUX_PKG_PROVIDES="termux-x11"

termux_step_make() {
	:
}

termux_step_make_install() {
	local DATA
	DATA="$(find . -type d -path '*/files/usr')"
	install -t "$TERMUX_PREFIX/bin" -m 755 "$DATA/bin/termux-x11" "$DATA/bin/termux-x11-preference"
	mkdir -p "$TERMUX_PREFIX/libexec/termux-x11"
	install -m 644 "$DATA/libexec/termux-x11/loader.apk" "$TERMUX_PREFIX/libexec/termux-x11/loader.apk"
}

termux_step_post_make_install() {
	# Setup termux-services scripts
	mkdir -p "$TERMUX_PREFIX/var/service/tx11/log"
	ln -sf "$TERMUX_PREFIX/share/termux-services/svlogger" "$TERMUX_PREFIX/var/service/tx11/log/run"
	sed -e "s%@TERMUX_PREFIX@%$TERMUX_PREFIX%g" \
		-e "s%@TERMUX_HOME@%$TERMUX_ANDROID_HOME%g" \
		"$TERMUX_PKG_BUILDER_DIR/sv/tx11.run.in" > "$TERMUX_PREFIX/var/service/tx11/run"
	chmod 700 "$TERMUX_PREFIX/var/service/tx11/run"
	touch "$TERMUX_PREFIX/var/service/tx11/down"

	mkdir -p "$TERMUX_PREFIX/var/service/tx11-xfce4/log"
	ln -sf "$TERMUX_PREFIX/share/termux-services/svlogger" "$TERMUX_PREFIX/var/service/tx11-xfce4/log/run"
	sed "s%@TERMUX_PREFIX@%$TERMUX_PREFIX%g" \
		"$TERMUX_PKG_BUILDER_DIR/sv/tx11-xfce4.run.in" > "$TERMUX_PREFIX/var/service/tx11-xfce4/run"
	chmod 700 "$TERMUX_PREFIX/var/service/tx11-xfce4/run"
	touch "$TERMUX_PREFIX/var/service/tx11-xfce4/down"
}

termux_step_create_debscripts() {
	cat <<- EOF > postinst
		#!${TERMUX_PREFIX}/bin/sh
		chmod -w $TERMUX_PREFIX/libexec/termux-x11/loader.apk
	EOF

	if [[ "$TERMUX_PACKAGE_FORMAT" == "pacman" ]]; then
		echo "post_install" > postupg
	fi
}
