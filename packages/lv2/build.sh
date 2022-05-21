TERMUX_PKG_HOMEPAGE=https://lv2plug.in/
TERMUX_PKG_DESCRIPTION="A plugin standard for audio systems"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.18.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://lv2plug.in/spec/lv2-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=4e891fbc744c05855beb5dfa82e822b14917dd66e98f82b8230dbd1c7ab2e05e
TERMUX_PKG_DEPENDS="libxml2, libxslt, python, sord"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--no-plugins"

termux_step_pre_configure() {
	./waf configure \
		--prefix="${TERMUX_PREFIX}" \
		LINKFLAGS="${LDFLAGS}" \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

termux_step_make() {
	./waf
}

termux_step_make_install() {
	./waf install
}

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!$TERMUX_PREFIX/bin/sh
		echo "Installing dependencies through pip..."
		pip3 install lxml pygments rdflib
	EOF
}
