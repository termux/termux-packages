TERMUX_PKG_HOMEPAGE=https://launchpad.net/intltool
TERMUX_PKG_DESCRIPTION="Automatically extracts translatable strings from oaf, glade, bonobo ui, nautilus theme and other XML files into the po files."
TERMUX_PKG_MAINTAINER="@suhan-paradkar"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.51.0
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_SRCURL=https://launchpad.net/intltool/trunk/$TERMUX_PKG_VERSION/+download/intltool-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=67c74d94196b153b774ab9f89b2fa6c6ba79352407037c8c14d5aeb334e959cd
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_create_debscripts()  {
	cat <<- POSTINST_EOF > ./postinst
	#!$TERMUX_PREFIX/bin/bash

	echo "Setting up intltool"

	cpan install XML::Parser

	exit 0
	POSTINST_EOF
}
