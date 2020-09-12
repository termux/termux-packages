TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="A session manager for XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=4.15.0
TERMUX_PKG_SRCURL=http://archive.xfce.org/src/xfce/xfce4-session/${TERMUX_PKG_VERSION:0:4}/xfce4-session-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=5977cd3e9b7c8396fb620835c8536ebfea477d1585a0100ec28d7e2fa951310b
TERMUX_PKG_DEPENDS="gnupg, hicolor-icon-theme, libsm, libwnck, libxfce4ui, xfce4-settings, xfdesktop, xfwm4, xorg-iceauth, xorg-xrdb"

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
