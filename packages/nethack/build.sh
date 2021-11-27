TERMUX_PKG_HOMEPAGE=http://www.nethack.org/
TERMUX_PKG_DESCRIPTION="Dungeon crawl game"
TERMUX_PKG_LICENSE="Nethack"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=3.6.6
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=http://www.nethack.org/download/${TERMUX_PKG_VERSION}/nethack-${TERMUX_PKG_VERSION//./}-src.tgz
TERMUX_PKG_SHA256=cfde0c3ab6dd7c22ae82e1e5a59ab80152304eb23fb06e3129439271e5643ed2
TERMUX_PKG_DEPENDS="gzip, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	cp -r $TERMUX_PKG_SRCDIR/* .
	pushd sys/unix
	sh setup.sh hints/linux
	popd && cd util
	if [ $TERMUX_ARCH_BITS = 32 ]; then
		HOST_CC="gcc -m32"
	else
		HOST_CC="gcc"
	fi
	CFLAGS="" CC="$HOST_CC" LD="ld" make makedefs
	CFLAGS="" CC="$HOST_CC" LD="ld" make lev_comp
	CFLAGS="" CC="$HOST_CC" LD="ld" make dgn_comp dlb recover
}

termux_step_pre_configure() {
	WINTTYLIB="$LDFLAGS -lcurses"
	export LFLAGS="$LDFLAGS"
	export CFLAGS="$CPPFLAGS $CFLAGS"
	cd sys/unix
	sh setup.sh hints/linux
}

termux_step_post_configure() {
	# cp hostbuilt tools from hostbuild dir
	cp $TERMUX_PKG_HOSTBUILD_DIR/util/{makedefs,lev_comp,dgn_comp,dlb} \
		util/
	touch -d "next hour" util/*
}

termux_step_post_make_install() {
	cd doc
	mkdir -p $TERMUX_PREFIX/share/man/man6
	install -m600 nethack.6 $TERMUX_PREFIX/share/man/man6/
	ln -sf $TERMUX_PREFIX/games/nethack $TERMUX_PREFIX/bin/
}

termux_step_create_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "mkdir -p $TERMUX_PREFIX/games/nethackdir/save" >> postinst
	echo "exit 0" >> postinst
}
