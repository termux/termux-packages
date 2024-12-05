TERMUX_PKG_HOMEPAGE=https://mariadb.org
TERMUX_PKG_DESCRIPTION="A drop-in replacement for mysql server"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2:11.6.1"
TERMUX_PKG_SRCURL=https://archive.mariadb.org/mariadb-${TERMUX_PKG_VERSION#*:}/source/mariadb-${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=98ea7aa7827b37af69d5eb20f21bb06a46bc5c7345ea8d42107ea2e5acd32cc5
TERMUX_PKG_DEPENDS="libandroid-support, libc++, libcrypt, libedit, liblz4, liblzma, ncurses, openssl, pcre2, zlib, zstd"
TERMUX_PKG_BREAKS="mariadb-dev"
TERMUX_PKG_CONFLICTS="mysql"
TERMUX_PKG_REPLACES="mariadb-dev"
TERMUX_PKG_SERVICE_SCRIPT=("mysqld" "exec mysqld --basedir=$TERMUX_PREFIX --datadir=$TERMUX_PREFIX/var/lib/mysql 2>&1")
TERMUX_PKG_HOSTBUILD=true
TERMUX_CMAKE_BUILD="Unix Makefiles"
TERMUX_PKG_AUTO_UPDATE=true
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
-DSTAT_EMPTY_STRING_BUG_EXITCODE=0
-DLSTAT_FOLLOWS_SLASHED_SYMLINK_EXITCODE=0
-DMASK_LONGDOUBLE_EXITCODE=1
-DINSTALL_SYSCONFDIR=$TERMUX_PREFIX/etc
"
TERMUX_PKG_RM_AFTER_INSTALL="
bin/rcmysql
bin/mysqltest*
share/man/man1/mysql-test-run.pl.1
share/mariadb/mariadb-test
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
	make -j $TERMUX_PKG_MAKE_PROCESSES import_executables
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

	export PATH=$TERMUX_PKG_HOSTBUILD_DIR/strings:$PATH
}

termux_step_post_massage() {
	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/etc/my.cnf.d

	# move vendored groonga docs to resolve file conflict with groonga
	mv $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/{groonga{,-normalizer-mysql},doc/mariadb/}
}

termux_step_create_debscripts() {
	echo "if [ ! -e "$TERMUX_PREFIX/var/lib/mysql" ]; then" > postinst
	echo "  echo 'Initializing mysql data directory...'" >> postinst
	echo "  mkdir -p $TERMUX_PREFIX/var/lib/mysql" >> postinst
	echo "  $TERMUX_PREFIX/bin/mariadb-install-db --user=root --auth-root-authentication-method=normal --datadir=$TERMUX_PREFIX/var/lib/mysql" >> postinst
	echo "fi" >> postinst
	echo "exit 0" >> postinst
	chmod 0755 postinst
}
