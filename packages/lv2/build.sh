TERMUX_PKG_HOMEPAGE=https://lv2plug.in/
TERMUX_PKG_DESCRIPTION="A plugin standard for audio systems"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.18.10
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://lv2plug.in/spec/lv2-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=78c51bcf21b54e58bb6329accbb4dae03b2ed79b520f9a01e734bd9de530953f
TERMUX_PKG_DEPENDS="libxml2, libxslt, python, sord, python-pip"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dplugins=disabled"
TERMUX_PKG_PYTHON_TARGET_DEPS="lxml, pygments, rdflib"

termux_step_create_debscripts() {
	cat <<-EOF >./postinst
		#!$TERMUX_PREFIX/bin/sh
		echo "Installing dependencies through pip..."
		pip3 install ${TERMUX_PKG_PYTHON_TARGET_DEPS//, / }
	EOF
}
