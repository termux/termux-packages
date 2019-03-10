TERMUX_PKG_HOMEPAGE=http://www.dest-unreach.org/socat/
TERMUX_PKG_DESCRIPTION="Relay for bidirectional data transfer between two independent data channels"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_DEPENDS="openssl, readline"
TERMUX_PKG_VERSION=1.7.3.2
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=http://www.dest-unreach.org/socat/download/socat-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ce3efc17e3e544876ebce7cd6c85b3c279fda057b2857fcaaf67b9ab8bdaf034
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_header_resolv_h=no ac_cv_c_compiler_gnu=yes ac_compiler_gnu=yes" # sc_cv_sys_crdly_shift=9 sc_cv_sys_csize_shift=4 sc_cv_sys_tabdly_shift=11"
TERMUX_PKG_BUILD_IN_SRC=yes
#TERMUX_PKG_HOSTBUILD=yes

termux_step_pre_configure() {
	LDFLAGS="$LDFLAGS -llog" # uses syslog
}

#termux_step_configure() {
	# From socat_buildscript_for_android.sh in socat source:
#./configure --host --disable-unix --disable-openssl --prefix=$TERMUX_PREFIX
	# Replace misconfigured values in config.h and enable PTY functions
#mv config.h config.old
#cat config.old \
#| sed 's/CRDLY_SHIFT.*/CRDLY_SHIFT 9/' \
#| sed 's/TABDLY_SHIFT.*/TABDLY_SHIFT 11/' \
#| sed 's/CSIZE_SHIFT.*/CSIZE_SHIFT 4/' \
#| sed 's/\/\* #undef HAVE_OPENPTY \*\//#define HAVE_OPENPTY 1/' \
#| sed 's/\/\* #undef HAVE_GRANTPT \*\//#define HAVE_GRANTPT 1/' \
#> config.h
	# Enable openpty() in Makefile
#mv Makefile Makefile.old
#cat Makefile.old | sed 's/error.c/error.c openpty.c/' > Makefile
#}
