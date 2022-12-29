TERMUX_PKG_HOMEPAGE=https://mariadb.org
TERMUX_PKG_DESCRIPTION="A drop-in replacement for mysql server"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2:10.9.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://ftp.hosteurope.de/mirror/archive.mariadb.org/mariadb-${TERMUX_PKG_VERSION:2}/source/mariadb-${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=1dff08a0f37ea5cf8f00cbd12d40e80759fae7d73184ccf56b5b51acfdcfc054
TERMUX_PKG_DEPENDS="libandroid-support, libc++, libcrypt, libedit, liblz4, liblzma, ncurses, openssl, pcre2, zlib"
TERMUX_PKG_BREAKS="mariadb-dev"
TERMUX_PKG_REPLACES="mariadb-dev"
TERMUX_PKG_SERVICE_SCRIPT=("mysqld" "exec mysqld --basedir=$TERMUX_PREFIX --datadir=$TERMUX_PREFIX/var/lib/mysql 2>&1")

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBISON_EXECUTABLE=$(command -v bison)
-DGETCONF=$(command -v getconf)
-DBUILD_CONFIG=mysql_release
-DCAT_EXECUTABLE=$(command -v cat)
-DGIT_EXECUTABLE=$(command -v git)
-DGSSAPI_FOUND=NO
-DGRN_WITH_LZ4=yes
-DENABLED_LOCAL_INFILE=ON
-DHAVE_UCONTEXT_H=False
-DIMPORT_EXECUTABLES=$TERMUX_PKG_HOSTBUILD_DIR/import_executables.cmake
-DINSTALL_LAYOUT=DEB
-DINSTALL_UNIX_ADDRDIR=$TERMUX_PREFIX/var/run/mysqld.sock
-DINSTALL_SBINDIR=$TERMUX_PREFIX/bin
-DMYSQL_DATADIR=$TERMUX_PREFIX/var/lib/mysql
-DPLUGIN_AUTH_GSSAPI_CLIENT=OFF
-DPLUGIN_AUTH_GSSAPI=NO
-DPLUGIN_AUTH_PAM=NO
-DPLUGIN_CONNECT=NO
-DPLUGIN_DAEMON_EXAMPLE=NO
-DPLUGIN_EXAMPLE=NO
-DPLUGIN_GSSAPI=OFF
-DPLUGIN_ROCKSDB=NO
-DPLUGIN_TOKUDB=NO
-DPLUGIN_SERVER_AUDIT=NO
-DSTACK_DIRECTION=-1
-DTMPDIR=$TERMUX_PREFIX/tmp
-DWITH_EXTRA_CHARSETS=complex
-DWITH_JEMALLOC=OFF
-DWITH_MARIABACKUP=OFF
-DWITH_PCRE=system
-DWITH_LZ4=system
-DWITH_READLINE=OFF
-DWITH_SSL=system
-DWITH_WSREP=False
-DWITH_ZLIB=system
-DWITH_INNODB_BZIP2=OFF
-DWITH_INNODB_LZ4=ON
-DWITH_INNODB_LZMA=ON
-DWITH_INNODB_LZO=OFF
-DWITH_INNODB_SNAPPY=OFF
-DWITH_UNIT_TESTS=OFF
-DINSTALL_SYSCONFDIR=$TERMUX_PREFIX/etc
"
TERMUX_PKG_HOSTBUILD=true
TERMUX_CMAKE_BUILD="Unix Makefiles"
TERMUX_PKG_CONFLICTS="mysql"

TERMUX_PKG_RM_AFTER_INSTALL="
bin/mysqltest*
share/man/man1/mysql-test-run.pl.1
share/mysql/mysql-test
mysql-test
sql-bench
"

termux_step_host_build() {
	termux_setup_cmake
	sed -i 's/^\s*END[(][)]/ENDIF()/g' $TERMUX_PKG_SRCDIR/libmariadb/cmake/ConnectorName.cmake
	cmake -G "Unix Makefiles" \
		$TERMUX_PKG_SRCDIR \
		-DWITH_SSL=bundled \
		-DCMAKE_BUILD_TYPE=Release
	make -j $TERMUX_MAKE_PROCESSES import_executables
}

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	CPPFLAGS+=" -Dushort=u_short"

	if [ $TERMUX_ARCH_BITS = 32 ]; then
		CPPFLAGS+=" -D__off64_t_defined"
	fi

	sed -i 's/^\s*END[(][)]/ENDIF()/g' $TERMUX_PKG_SRCDIR/libmariadb/cmake/ConnectorName.cmake

}

termux_step_post_massage() {
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/etc/my.cnf.d
}

termux_step_create_debscripts() {
	echo "if [ ! -e "$TERMUX_PREFIX/var/lib/mysql" ]; then" > postinst
	echo "  echo 'Initializing mysql data directory...'" >> postinst
	echo "  mkdir -p $TERMUX_PREFIX/var/lib/mysql" >> postinst
	echo "  $TERMUX_PREFIX/bin/mysql_install_db --user=root --auth-root-authentication-method=normal --datadir=$TERMUX_PREFIX/var/lib/mysql --basedir=$TERMUX_PREFIX" >> postinst
	echo "fi" >> postinst
	echo "exit 0" >> postinst
	chmod 0755 postinst
}
