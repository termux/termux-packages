TERMUX_PKG_HOMEPAGE=https://www.postgresql.org
TERMUX_PKG_DESCRIPTION="Object-relational SQL database"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER='Vishal Biswas @vishalbiswas'
TERMUX_PKG_VERSION=11.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=02802ddffd1590805beddd1e464dd28a46a41a5f1e1df04bab4f46663195cc8b
TERMUX_PKG_SRCURL=https://ftp.postgresql.org/pub/source/v$TERMUX_PKG_VERSION/postgresql-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_DEPENDS="openssl, libcrypt, readline, libandroid-shmem, libuuid, libxml2, libicu, zlib"
# - pgac_cv_prog_cc_ldflags__Wl___as_needed: Inform that the linker supports as-needed. It's
#   not stricly necessary but avoids unnecessary linking of binaries.
# - USE_UNNAMED_POSIX_SEMAPHORES: Avoid using System V semaphores which are disabled on Android.
# - ZIC=...: The zic tool is used to build the time zone database bundled with postgresql.
#   We specify a binary built in termux_step_host_build which has been patched to use symlinks
#   over hard links (which are not supported as of Android 6.0+).
#   There exists a --with-system-tzdata configure flag, but that does not work here as Android
#   uses a custom combined tzdata file.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
pgac_cv_prog_cc_ldflags__Wl___as_needed=yes
USE_UNNAMED_POSIX_SEMAPHORES=1
--with-icu
--with-libxml
--with-openssl
--with-uuid=e2fs
ZIC=$TERMUX_PKG_HOSTBUILD_DIR/src/timezone/zic
"
TERMUX_PKG_EXTRA_MAKE_ARGS=" -s"
TERMUX_PKG_RM_AFTER_INSTALL="lib/libecpg* bin/ecpg share/man/man1/ecpg.1"
TERMUX_PKG_HOSTBUILD=yes
TERMUX_PKG_BREAKS="postgresql-contrib (<= 10.3-1), postgresql-dev"
TERMUX_PKG_REPLACES="postgresql-contrib (<= 10.3-1), postgresql-dev"

termux_step_host_build() {
	# Build a native zic binary which we have patched to
	# use symlinks instead of hard links.
	$TERMUX_PKG_SRCDIR/configure --without-readline
	make ./src/timezone/zic
}

termux_step_post_make_install() {
	# Man pages are not installed by default:
	make -C doc/src/sgml install-man

	for contrib in \
		hstore \
		pageinspect \
		pgcrypto \
		pgrowlocks \
		pg_freespacemap \
		pg_stat_statements\
		pg_trgm \
		fuzzystrmatch \
		unaccent \
		uuid-ossp \
		; do
		(cd contrib/$contrib && make -s -j $TERMUX_MAKE_PROCESSES install)
	done
}

termux_step_post_massage() {
	# Remove bin/pg_config so e.g. php doesn't try to use it, which won't
	# work as it's a cross-compiled binary:
	rm $TERMUX_PREFIX/bin/pg_config
}
