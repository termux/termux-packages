TERMUX_PKG_HOMEPAGE=https://nethackwiki.com/wiki/Slash%27EM_Extended
TERMUX_PKG_DESCRIPTION="A variant of SLASH'EM (a variant of NetHack)"
TERMUX_PKG_LICENSE="Nethack"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.7.0
TERMUX_PKG_SRCURL=https://github.com/SLASHEM-Extended/SLASHEM-Extended/archive/refs/tags/slex-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=54d301bcb8d79d92030a30195f091e694f843d4656061dbce85730fc12023dee
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	for s in dgn lev; do
		ln -sf ${s}_comp.h include/${s}.tab.h
	done
	for f in alloc.c decl.c dlb.c drawing.c monst.c objects.c; do
		ln -sf ../src/$f util/$f
	done
}

termux_step_make() {
	CFLAGS+=" -fcommon -DMAILPATH=\\\"/dev/null\\\""
	export CFLAGS_FOR_BUILD="-m${TERMUX_ARCH_BITS} -O2 -fcommon"
	export LDFLAGS_FOR_BUILD="-m${TERMUX_ARCH_BITS}"
	make -f sys/unix/GNUmakefile
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin "$TERMUX_PKG_BUILDDIR/src/slex"
	install -Dm600 -t $TERMUX_PREFIX/share/games/slex "$TERMUX_PKG_BUILDDIR/dat/nhdat"
	install -Dm600 -t $TERMUX_PREFIX/share/doc/slex "$TERMUX_PKG_SRCDIR/dat/license"
}

termux_step_create_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "mkdir -p \$TERMUX_PREFIX/var/games/slex" >> postinst
	echo "touch \$TERMUX_PREFIX/var/games/slex/perm" >> postinst
	echo "touch \$TERMUX_PREFIX/var/games/slex/record" >> postinst
	echo "mkdir -p \$TERMUX_PREFIX/var/games/slex/save" >> postinst
	echo "mkdir -p \$TERMUX_PREFIX/var/games/slex/unshare" >> postinst
	echo "exit 0" >> postinst
	chmod 0755 postinst
}
