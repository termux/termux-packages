TERMUX_PKG_HOMEPAGE=https://starship.rs
TERMUX_PKG_DESCRIPTION="A minimal, blazing fast, and extremely customizable prompt for any shell"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_VERSION=0.35.1
TERMUX_PKG_SRCURL=https://github.com/starship/starship/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=22b4bf8bfe45d492d69433942e02731b141091f11b03860cb02d21f4f2431285
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--no-default-features"

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS"
	if [ $TERMUX_ARCH = arm ]; then
		CFLAGS+=" -fno-integrated-as"
	fi
}

