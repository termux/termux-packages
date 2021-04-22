TERMUX_PKG_HOMEPAGE=https://launchpad.net/intltool
TERMUX_PKG_DESCRIPTION="Automatically extracts transl$
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_LICENSE="GNU v2.0"
TERMUX_PKG_VERSION=0.51.0
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_SRCURL=https://launchpad.net/intltool/trun$
TERMUX_PKG_SHA256=67c74d94196b153b774ab9f89b2fa6c6ba7$
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--prefix=$TERMUX_PRE$
termux_step_pre_configure() {
cpan install XML::Parser
}
termux_step_install_license() {
mkdir -p $TERMUX_PREFIX/share/doc/intltool
cp $TERMUX_PKG_BUILDER_DIR/LICENSE $TERMUX_PREFIX/sha$
}
