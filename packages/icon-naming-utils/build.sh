TERMUX_PKG_HOMEPAGE=http://tango.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Maps the new names of icons for Tango to the legacy names used by the GNOME and KDE desktops"
TERMUX_PKG_LICENSE="GPL-2.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.90"
TERMUX_PKG_SRCURL="https://tango.freedesktop.org/releases/icon-naming-utils-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=044ab2199ed8c6a55ce36fd4fcd8b8021a5e21f5bab028c0a7cdcf52a5902e1c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--sysconfdir=$TERMUX_PREFIX/etc
--localstatedir=$TERMUX_PREFIX/var
"

termux_step_pre_configure() {
	autoreconf -fi
}

termux_step_create_debscripts()  {
	cat <<- POSTINST_EOF > ./postinst
	#!$TERMUX_PREFIX/bin/bash
	set -e

	export PERL_MM_USE_DEFAULT=1

	echo "Sideloading Perl XML::Simple ..."
	cpan -Ti XML::Simple

	exit 0
	POSTINST_EOF
}
