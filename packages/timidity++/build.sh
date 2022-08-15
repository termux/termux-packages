TERMUX_PKG_HOMEPAGE=http://timidity.sourceforge.net/
TERMUX_PKG_DESCRIPTION="MIDI-to-WAVE converter and player"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.15.0
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/timidity/TiMidity++-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=9eaf4fadb0e19eb8e35cd4ac16142d604c589e43d0e8798237333697e6381d39
TERMUX_PKG_CONFFILES="
share/timidity/timidity.cfg
"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-dynamic
--enable-vt100
--enable-server
--enable-network
--with-module-dir=$TERMUX_PREFIX/share/timidity
lib_cv_va_copy=yes
lib_cv___va_copy=yes
lib_cv_va_val_copy=yes
"

termux_step_pre_configure() {
	autoreconf -fi
}

termux_step_post_configure() {
	mkdir -p _build
	$CC_FOR_BUILD $TERMUX_PKG_SRCDIR/timidity/calcnewt.c \
		-o _build/calcnewt -lm
	export PATH="$(pwd)/_build:$PATH"

	ln -sf $TERMUX_PKG_SRCDIR/timidity/resample.c timidity/
}

termux_step_post_make_install() {
	sed "s:@TERMUX_PREFIX@:$TERMUX_PREFIX:g" \
		$TERMUX_PKG_BUILDER_DIR/timidity.cfg > timidity.cfg
	install -Dm600 -t $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/timidity \
		timidity.cfg
}
