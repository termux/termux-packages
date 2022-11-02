TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="A session manager for XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=4.17
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.1
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/xfce4-session/${_MAJOR_VERSION}/xfce4-session-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=6c2d1dd49200a4f4e39a9459b055d8c1792188d4fb23400eff5a6795b204a48b
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, libcairo, libice, libsm, libwnck, libx11, libxfce4ui, libxfce4util, pango, xfconf, xorg-iceauth, xorg-xrdb"
TERMUX_PKG_RECOMMENDS="gnupg, hicolor-icon-theme, xfce4-settings, xfdesktop, xfwm4"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_path_ICEAUTH=${TERMUX_PREFIX}/bin/iceauth
--with-xsession-prefix=$TERMUX_PREFIX
"

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" = "configure" ] || [ "\$1" = "abort-upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --install \
				$TERMUX_PREFIX/bin/x-session-manager x-session-manager $TERMUX_PREFIX/bin/xfce4-session 50
		fi
	fi
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" != "upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --remove x-session-manager $TERMUX_PREFIX/bin/xfce4-session
		fi
	fi
	EOF
}
