TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X.Org X Window System initializer"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.4"
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/app/xinit-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=40a47c7a164c7f981ce3787b4b37f7e411fb43231dcde543d70094075dacfef9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libx11, xorg-xauth, dialog"
# Any one of the servers registering itself for $PREFIX/bin/X will do.
TERMUX_PKG_RECOMMENDS="termux-x11-nightly | tigervnc | xorg-server, dbus"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"
TERMUX_PKG_CONFFILES="etc/X11/xinit/xinitrc etc/X11/xinit/xserverrc"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-xinitdir=$TERMUX_PREFIX/etc/X11/xinit
--with-xserver=$TERMUX_PREFIX/bin/X
"

termux_step_pre_configure() {
	if [[ $TERMUX_ON_DEVICE_BUILD == false ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_path_RAWCPP=/usr/bin/cpp"
	fi
}

termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX/libexec/xorg-xinit"
	"$CC" $CFLAGS $LDFLAGS -o "$TERMUX_PREFIX/libexec/xorg-xinit/fgrun" \
		"$TERMUX_PKG_BUILDER_DIR/fgrun.c"

	install -Dm755 "$TERMUX_PKG_BUILDER_DIR/xserverrc" "$TERMUX_PREFIX/etc/X11/xinit/xserverrc"
	install -Dm755 "$TERMUX_PKG_BUILDER_DIR/xinitrc" "$TERMUX_PREFIX/etc/X11/xinit/xinitrc"
	install -Dm755 "$TERMUX_PKG_BUILDER_DIR/x-session-picker" "$TERMUX_PREFIX/etc/X11/xinit/x-session-picker"
	for f in etc/X11/xinit/xserverrc etc/X11/xinit/xinitrc etc/X11/xinit/x-session-picker; do
		sed -i "s%@TERMUX_PREFIX@%$TERMUX_PREFIX%g" "$TERMUX_PREFIX/$f"
	done
}
