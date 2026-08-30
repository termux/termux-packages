TERMUX_PKG_HOMEPAGE=https://gitlab.com/procps-ng/procps
TERMUX_PKG_DESCRIPTION="Utilities that give information about processes using the /proc filesystem"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.0.7"
TERMUX_PKG_SRCURL="https://sourceforge.net/projects/procps-ng/files/Production/procps-ng-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=9d2021f47a4501c667862c9942a92d1953694b21d11bcd1702e83eb594e3d67d
TERMUX_PKG_DEPENDS="libandroid-glob, libandroid-support, ncurses"
TERMUX_PKG_BREAKS="procps-dev"
TERMUX_PKG_REPLACES="procps-dev"
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_search_dlopen=
--enable-sigwinch
--enable-watch8bit
--disable-kill
--disable-modern-top
--without-systemd
"

# About kill: https://bugs.launchpad.net/ubuntu/+source/coreutils/+bug/141168:
# "For compatibility between distributions, can we have /bin/kill made available from coreutils?"
# About top: The system top works better.
TERMUX_PKG_RM_AFTER_INSTALL="
bin/top share/man/man1/top.1
bin/kill share/man/man1/kill.1
bin/slabtop share/man/man1/slabtop.1
bin/w share/man/man1/w.1
"

termux_step_pre_configure() {
	LDFLAGS+=" -L${TERMUX_PKG_SRCDIR}"

	# older than Android 9 don't have hsearch normally
	cp "${TERMUX_PKG_BUILDER_DIR}"/hsearch/*.h "${TERMUX_PKG_SRCDIR}/library/include"
	"${CC}" ${CPPFLAGS} ${CFLAGS} -c "${TERMUX_PKG_BUILDER_DIR}"/hsearch/hcreate_r.c
	"${CC}" ${CPPFLAGS} ${CFLAGS} -c "${TERMUX_PKG_BUILDER_DIR}"/hsearch/hcreate.c
	"${CC}" ${CPPFLAGS} ${CFLAGS} -c "${TERMUX_PKG_BUILDER_DIR}"/hsearch/hdestroy_r.c
	"${CC}" ${CPPFLAGS} ${CFLAGS} -c "${TERMUX_PKG_BUILDER_DIR}"/hsearch/hsearch_r.c
	"${AR}" cru libhsearch.a hcreate_r.o hcreate.o hdestroy_r.o hsearch_r.o
	LDFLAGS+=" -l:libhsearch.a"

	# Android doesn't have strverscmp normally
	cp "${TERMUX_PKG_BUILDER_DIR}"/strverscmp.h "${TERMUX_PKG_SRCDIR}/library/include"
	"${CC}" ${CPPFLAGS} ${CFLAGS} -c "${TERMUX_PKG_BUILDER_DIR}"/strverscmp.c
	"${AR}" cru libstrverscmp.a strverscmp.o
	LDFLAGS+=" -l:libstrverscmp.a"

	# older than Android 8 don't have mblen normally
	LDFLAGS+=" -landroid-support"

	# older than Android 9 don't have glob normally
	LDFLAGS+=" -landroid-glob"

	# Android does not have permission to acccess /proc/stat without root
	CPPFLAGS+=" -DMOCK_STAT_FILE=\\\"$TERMUX_PREFIX/var/procps/stat\\\""

	autoreconf -fi
}

termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX/var/procps"
	cp -a "$(readlink -f "$TERMUX_PKG_BUILDER_DIR/procstat")" \
		"$TERMUX_PREFIX/var/procps/stat"
}
