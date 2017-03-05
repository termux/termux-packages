TERMUX_PKG_HOMEPAGE=https://www.postgresql.org
TERMUX_PKG_DESCRIPTION="Object-relational SQL database"
TERMUX_PKG_MAINTAINER='Vishal Biswas @vishalbiswas'
TERMUX_PKG_VERSION=9.6.2
TERMUX_PKG_SRCURL=https://ftp.postgresql.org/pub/source/v$TERMUX_PKG_VERSION/postgresql-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=0187b5184be1c09034e74e44761505e52357248451b0c854dddec6c231fe50c9
TERMUX_PKG_DEPENDS="openssl, libcrypt, readline, libandroid-shmem"
# - pgac_cv_prog_cc_ldflags__Wl___as_needed: Inform that the linker supports as-needed. It's
#   not stricly necessary but avoids unnecessary linking of binaries.
# - USE_UNNAMED_POSIX_SEMAPHORES: Avoid using System V semaphores which are disabled on Android.
# - with-system-tzdata: Doesn't currently work as Android uses a single timezone file. But
#   if not specified the build uses zic to build timezone files using hard links, which doesn't
#   work on Android 6.0+. TODO: Either patch to work with the combined timezone file, or
#   replace the hard links with symlinks.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
pgac_cv_prog_cc_ldflags__Wl___as_needed=yes
USE_UNNAMED_POSIX_SEMAPHORES=1
--with-openssl
--with-system-tzdata=/system/usr/share/zoneinfo
"
TERMUX_PKG_EXTRA_MAKE_ARGS=" -s"
TERMUX_PKG_RM_AFTER_INSTALL="lib/libecpg* bin/ecpg share/man/man1/ecpg.1"

termux_step_post_make_install() {
	# Man pages are not installed by default:
	make -C doc/src/sgml install-man

	# Sync with postgresql-contrib.subpackage.sh:
	for contrib in hstore pgcrypto pg_stat_statements; do
		(cd contrib/$contrib && make -s -j $TERMUX_MAKE_PROCESSES install)
	done
}
