TERMUX_PKG_HOMEPAGE=https://sendxmpp.hostname.sk/
TERMUX_PKG_DESCRIPTION="A perl-script to send XMPP (jabber) messages"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.24
TERMUX_PKG_SRCURL=https://github.com/lhost/sendxmpp/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dfaf735b4585efd6b3b0f95db31203f9ab0fe607b50e75c6951bc18a6269837d
TERMUX_PKG_DEPENDS="perl, clang, make"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin sendxmpp
}

termux_step_create_debscripts()  {
	cat <<- POSTINST_EOF > ./postinst
	#!$TERMUX_PREFIX/bin/bash
	set -e

	echo "Sideloading Perl Authen::SASL and Net::XMPP ..."
	cpan -fi Authen::SASL Net::XMPP

	exit 0
	POSTINST_EOF
}
