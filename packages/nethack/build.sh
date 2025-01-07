TERMUX_PKG_HOMEPAGE=http://www.nethack.org/
TERMUX_PKG_DESCRIPTION="Dungeon crawl game"
TERMUX_PKG_LICENSE="Nethack"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.6.7
TERMUX_PKG_SRCURL=https://www.nethack.org/download/${TERMUX_PKG_VERSION}/nethack-${TERMUX_PKG_VERSION//./}-src.tgz
TERMUX_PKG_SHA256=98cf67df6debf9668a61745aa84c09bcab362e5d33f5b944ec5155d44d2aacb2
TERMUX_PKG_DEPENDS="gzip, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_GROUPS="games"

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
