TERMUX_PKG_VERSION=10.1.21
TERMUX_PKG_HOMEPAGE=https://mariadb.org
TERMUX_PKG_SRCURL=http://mirror.fibergrid.in/mariadb//mariadb-$TERMUX_PKG_VERSION/source/mariadb-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=5a816355781ea22a6c65a436d8162f19bd292ec90e2b7d9499c031ae4a659490
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" -DSTACK_DIRECTION=-1 -DIMPORT_EXECUTABLES=$TERMUX_PKG_HOSTBUILD_DIR/import_executables.cmake -DPLUGIN_EXAMPLE=NO
-DCMAKE_USE_SYSTEM_LIBRARIES=True -DWITH_WSREP=False -DHAVE_UCONTEXT_H=False -DWITH_READLINE=ON -DWITH_PCRE=system -DWITH_JEMALLOC=OFF
-DWITH_SSL=system -DPLUGIN_DAEMON_EXAMPLE=NO -DINSTALL_UNIX_ADDRDIR=$TERMUX_PREFIX/tmp/mysqld.sock -DINSTALL_SCRIPTDIR=$TERMUX_PREFIX/bin
-DWITH_EXTRA_CHARSETS=complex -DMYSQL_DATADIR=$TERMUX_PREFIX/var/lib/mysql -DINSTALL_MANDIR=$TERMUX_PREFIX/share/man
-DINSTALL_PLUGINDIR=$TERMUX_PREFIX/lib/mysql/plugin -DBUILD_CONFIG=mysql_release -DENABLED_LOCAL_INFILE=ON -DTMPDIR=$TERMUX_PREFIX/tmp" #-DHAVE_IB_GCC_ATOMIC_BUILTINS=True
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="openssl, pcre, libcrypt, libbz2, libandroid-support, libandroid-glob, krb5, libgnustl"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_DESCRIPTION="A drop-in replacement for mysql server"
TERMUX_PKG_CONFLICTS="mysql"

termux_step_host_build () {
	termux_setup_cmake
	cmake -G "Unix Makefiles" $TERMUX_PKG_SRCDIR -DCMAKE_BUILD_TYPE=Release
	make -j $TERMUX_MAKE_PROCESSES import_executables
}

termux_step_pre_configure () {
	# it will try to define off64_t with off_t if unset
	# and 32 bit Android has wrong off_t defined
	CPPFLAGS="$CPPFLAGS -Dushort=u_short -D__off64_t_defined"
}

termux_step_post_make_install () {
	mkdir -p $TERMUX_PREFIX/var/lib/mysql
	# files not needed
	rm -r $TERMUX_PREFIX/{data,mysql-test,sql-bench}
	rm $TERMUX_PREFIX/share/man/man1/mysql-test-run.pl.1
}

termux_step_create_debscripts () {
	return
	echo "echo 'Initializing mysql data directory...'" > postinst
	echo "$TERMUX_PREFIX/bin/mysql_install_db --user=\`whoami\` --datadir=$TERMUX_PREFIX/var/lib/mysql --basedir=$TERMUX_PREFIX" >> postinst
	echo "exit 0" >> postinst
	chmod 0755 postinst
}
