TERMUX_PKG_HOMEPAGE=https://launchpad.net/intltool
TERMUX_PKG_DESCRIPTION="The internationalization tool collection"
TERMUX_PKG_MAINTAINER="@suhan-paradkar"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.51.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://launchpad.net/intltool/trunk/$TERMUX_PKG_VERSION/+download/intltool-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=67c74d94196b153b774ab9f89b2fa6c6ba79352407037c8c14d5aeb334e959cd
TERMUX_PKG_DEPENDS="perl, clang, make, libexpat"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_create_debscripts()  {
	cat <<- POSTINST_EOF > ./postinst
	#!$TERMUX_PREFIX/bin/bash
	set -e

	echo "Sideloading Perl XML::Parser..."
	cpan install XML::Parser

	exit 0
	POSTINST_EOF
}
