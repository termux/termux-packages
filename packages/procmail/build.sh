TERMUX_PKG_HOMEPAGE=https://github.com/BuGlessRB/procmail
TERMUX_PKG_DESCRIPTION="Versatile e-mail processor"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.24
TERMUX_PKG_SRCURL=https://github.com/BuGlessRB/procmail/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=514ea433339783e95df9321e794771e4887b9823ac55fdb2469702cf69bd3989
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_MAKE_ARGS="BASENAME=${TERMUX_PREFIX}
MANDIR=${TERMUX_PREFIX}/share/man
LIBPATHS=${TERMUX_PREFIX}/lib
"

termux_step_pre_configure() {
	# Tests cannot be run while cross-compiling, so hardcode the results.
	echo "exit 0" >src/autoconf
	cat <<-EOF >autoconf.h
		/* 2 moves in 64 steps of size 16384 when reallocing */
		#define WMACROS_NON_POSIX
		#define NOpw_passwd
		#define NOpw_class
		#define NOpw_gecos
		#define NOsetrgid
		#define NOsetegid
		#define endhostent()
		#define endprotoent()
		#define MAX_argc 83725
		/* Your system's strstr() is 38.00 times FASTER than my C-routine */
		#define NO_COMSAT
		#ifndef MAILSPOOLDIR
		#define MAILSPOOLDIR "${TERMUX_PREFIX}/var/spool/mail/"
		#endif
		#define SENDMAIL ""
		#define DEFflagsendmail ""
		#define CF_no_procmail_yet
		#define buggy_SENDMAIL
		#define defPATH "PATH=${TERMUX_ANDROID_HOME}/bin:${TERMUX_ANDROID_HOME}/.local/bin:${TERMUX_PREFIX}/bin"
		#define defSPATH "PATH=${TERMUX_ANDROID_HOME}/.local/bin:${TERMUX_PREFIX}/bin"
		#define PM_VERSION "${TERMUX_PKG_VERSION}"
		/*locktype: 4, countlocks: 0, timeout 0, watchdog 8,
		 * /data/data/com.termux/files/home/dev/procmail-3.24.mod/test/_locktest*/
		/*locktype: 6, countlocks: 0, timeout 0, watchdog 8,
		 * /data/data/com.termux/files/home/dev/procmail-3.24.mod/test/_locktest*/
		/*locktype: 7, countlocks: 0, timeout 0, watchdog 8,
		 * /data/data/com.termux/files/home/dev/procmail-3.24.mod/test/_locktest*/
		/* Hotwire LOCKINGTEST=111 */
		/* Procmail will lock via: dotlocking, fcntl(), lockf(), flock() */
		#define USElockf
		#define USEflock
		/* autoconf completed */
	EOF
}

termux_step_make() {
	# shellcheck disable=SC2086 # We want splitting of TERMUX_PKG_EXTRA_MAKE_ARGS.
	make CFLAGS0="${CFLAGS}" LDFLAGS0="${LDFLAGS}" STRIP="${STRIP}" $TERMUX_PKG_EXTRA_MAKE_ARGS
}

termux_step_make_install() {
	make install
}
