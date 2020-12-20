TERMUX_PKG_HOMEPAGE=https://talloc.samba.org/talloc/doc/html/index.html
TERMUX_PKG_DESCRIPTION="Hierarchical, reference counted memory pool system with destructors"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.1
TERMUX_PKG_SRCURL=https://www.samba.org/ftp/talloc/talloc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ef4822d2fdafd2be8e0cabc3ec3c806ae29b8268e932c5e9a4cd5585f37f9f77
TERMUX_PKG_BREAKS="libtalloc-dev"
TERMUX_PKG_REPLACES="libtalloc-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	# Force fresh install:
	rm -f $TERMUX_PREFIX/include/talloc.h

	# Make sure symlinks are installed:
	rm $TERMUX_PREFIX/lib/libtalloc* || true

	cd $TERMUX_PKG_SRCDIR

	cat <<EOF > cross-answers.txt
Checking uname sysname type: "Linux"
Checking uname machine type: "dontcare"
Checking uname release type: "dontcare"
Checking uname version type: "dontcare"
Checking simple C program: OK
building library support: OK
Checking for large file support: OK
Checking for -D_FILE_OFFSET_BITS=64: OK
Checking for WORDS_BIGENDIAN: OK
Checking for C99 vsnprintf: OK
Checking for HAVE_SECURE_MKSTEMP: OK
rpath library support: OK
-Wl,--version-script support: FAIL
Checking correct behavior of strtoll: OK
Checking correct behavior of strptime: OK
Checking for HAVE_IFACE_GETIFADDRS: OK
Checking for HAVE_IFACE_IFCONF: OK
Checking for HAVE_IFACE_IFREQ: OK
Checking getconf LFS_CFLAGS: OK
Checking for large file support without additional flags: OK
Checking for working strptime: OK
Checking for HAVE_SHARED_MMAP: OK
Checking for HAVE_MREMAP: OK
Checking for HAVE_INCOHERENT_MMAP: OK
Checking getconf large file support flags work: OK
EOF

	./configure --prefix=$TERMUX_PREFIX \
		--disable-rpath \
		--disable-python \
		--cross-compile \
		--cross-answers=cross-answers.txt
}

termux_step_post_make_install() {
	cd $TERMUX_PKG_SRCDIR/bin/default
	$AR rcu libtalloc.a talloc*.o
	install -Dm600 libtalloc.a $TERMUX_PREFIX/lib/libtalloc.a
}
