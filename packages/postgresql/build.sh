TERMUX_PKG_HOMEPAGE=https://www.postgresql.org
TERMUX_PKG_DESCRIPTION="Object-relational SQL database"
TERMUX_PKG_LICENSE="PostgreSQL"
TERMUX_PKG_LICENSE_FILE="COPYRIGHT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="17.0"
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://ftp.postgresql.org/pub/source/v$TERMUX_PKG_VERSION/postgresql-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=7e276131c0fdd6b62588dbad9b3bb24b8c3498d5009328dba59af16e819109de
TERMUX_PKG_DEPENDS="libandroid-execinfo, libandroid-shmem, libicu, libuuid, libxml2, openssl, readline, zlib"
# - pgac_cv_prog_cc_LDFLAGS_EX_BE__Wl___export_dynamic: Needed to fix PostgreSQL 16 that
#   causes initdb failure: cannot locate symbol
# - pgac_cv_prog_cc_LDFLAGS__Wl___as_needed: Inform that the linker supports as-needed. It's
#   not stricly necessary but avoids unnecessary linking of binaries.
# - USE_UNNAMED_POSIX_SEMAPHORES: Avoid using System V semaphores which are disabled on Android.
# - ZIC=...: The zic tool is used to build the time zone database bundled with postgresql.
#   We specify a binary built in termux_step_host_build which has been patched to use symlinks
#   over hard links (which are not supported as of Android 6.0+).
#   There exists a --with-system-tzdata configure flag, but that does not work here as Android
#   uses a custom combined tzdata file.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-icu
--with-libxml
--with-openssl
--with-uuid=e2fs
USE_UNNAMED_POSIX_SEMAPHORES=1
ZIC=${TERMUX_PKG_HOSTBUILD_DIR}/src/timezone/zic
pgac_cv_prog_cc_LDFLAGS_EX_BE__Wl___export_dynamic=yes
pgac_cv_prog_cc_LDFLAGS__Wl___as_needed=yes
"
TERMUX_PKG_RM_AFTER_INSTALL="
bin/ecpg
lib/libecpg*
share/man/man1/ecpg.1
"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_BREAKS="postgresql-contrib (<= 10.3-1), postgresql-dev"
TERMUX_PKG_REPLACES="postgresql-contrib (<= 10.3-1), postgresql-dev"
TERMUX_PKG_SERVICE_SCRIPT=("postgres" "mkdir -p ~/.postgres\nif [ -f \"~/.postgres/postgresql.conf\" ]; then DATADIR=\"~/.postgres\"; else DATADIR=\"$TERMUX_PREFIX/var/lib/postgresql\"; fi\nexec postgres -D \$DATADIR 2>&1")

termux_step_host_build() {
	# Build a native zic binary which we have patched to
	# use symlinks instead of hard links.
	$TERMUX_PKG_SRCDIR/configure --without-readline
	make -j "${TERMUX_PKG_MAKE_PROCESSES}"
}

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi
}

termux_step_post_make_install() {
	# Man pages are not installed by default:
	make -C doc/src/sgml install-man

	for contrib in \
		btree_gin \
		btree_gist \
		citext \
		dblink \
		fuzzystrmatch \
		hstore \
		pageinspect \
		pg_freespacemap \
		pg_stat_statements \
		pg_trgm \
		pgcrypto \
		pgrowlocks \
		postgres_fdw \
		tablefunc \
		unaccent \
		uuid-ossp \
		; do
		(make -C contrib/${contrib} -s -j ${TERMUX_PKG_MAKE_PROCESSES} install)
	done
}
