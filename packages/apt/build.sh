TERMUX_PKG_HOMEPAGE=https://packages.debian.org/apt
TERMUX_PKG_DESCRIPTION="Front-end for the dpkg package manager"
TERMUX_PKG_DEPENDS="liblzma, dpkg, gpgv"
# Wait with updating to later version until the NDK supports std::to_string() and other
# functions (hopefully in r15, https://github.com/android-ndk/ndk/issues/82).
# Updating to apt 1.4 will also get rid of the build hacks used as apt has transitioned
# to a clean cmake build system.
TERMUX_PKG_VERSION=1.2.12
TERMUX_PKG_REVISION=2
# TERMUX_PKG_SRCURL=http://ftp.debian.org/debian/pool/main/a/apt/apt_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SRCURL=https://launchpad.net/ubuntu/+archive/primary/+files/apt_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=e820d27cba73476df4abcff27dadd1b5847474bfe85f7e9202a9a07526973ea6
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--no-create ac_cv_lib_bz2_BZ2_bzopen=no"
TERMUX_PKG_FOLDERNAME=apt-${TERMUX_PKG_VERSION}
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_ESSENTIAL=yes
TERMUX_PKG_CONFFILES="etc/apt/sources.list"

termux_step_pre_configure () {
	# Some files use STD*_FILENO without including <unistd.h> where they are declared.
	# Define them here to avoid having to patch files:
	CXXFLAGS+=" -DSTDIN_FILENO=0 -DSTDOUT_FILENO=1 -DSTDERR_FILENO=2 -DAI_IDN=0"

	cp $TERMUX_SCRIPTDIR/scripts/config.{guess,sub} $TERMUX_PKG_SRCDIR/buildlib
	perl -p -i -e "s/TERMUX_ARCH/$TERMUX_ARCH/" $TERMUX_PKG_SRCDIR/configure

	rm $TERMUX_PKG_SRCDIR/apt-pkg/{cdrom.cc,indexcopy.cc}
}

termux_step_make_install () {
	cp $TERMUX_PKG_BUILDDIR/build/bin/apt{,-get,-cache,-config,-key} $TERMUX_PREFIX/bin/
	cp $TERMUX_PKG_BUILDDIR/build/bin/libapt-{pkg.so.5.0.0,private.so.0.0} $TERMUX_PREFIX/lib/
	(cd $TERMUX_PREFIX/lib; ln -s -f libapt-pkg.so.5.0.0 libapt-pkg.so.5.0; ln -s -f libapt-pkg.so.5.0.0 libapt-pkg.so )
	mkdir -p $TERMUX_PREFIX/lib/apt/methods $TERMUX_PREFIX/share/man/man{5,8}
	cp $TERMUX_PKG_BUILDDIR/build/docs/apt{,-cache,-get}.8 $TERMUX_PREFIX/share/man/man8/
	cp $TERMUX_PKG_BUILDDIR/build/docs/{apt.conf,sources.list}.5 $TERMUX_PREFIX/share/man/man5/
	cp $TERMUX_PKG_BUILDDIR/build/bin/methods/{copy,file,gpgv,gzip,http,https,rsh,store} $TERMUX_PREFIX/lib/apt/methods
	(cd $TERMUX_PREFIX/lib/apt/methods; ln -f -s gzip xz)
	(cd $TERMUX_PREFIX/lib/apt/methods; ln -f -s rsh ssh)

	mkdir -p $TERMUX_PREFIX/etc/apt
	printf "# The main termux repository:\ndeb [arch=all,${TERMUX_ARCH}] http://termux.net stable main\n" > $TERMUX_PREFIX/etc/apt/sources.list

	# The trusted.gpg was created with "apt-key add public-key.key":
	cp $TERMUX_PKG_BUILDER_DIR/trusted.gpg $TERMUX_PREFIX/etc/apt/

	mkdir -p $TERMUX_PREFIX/etc/bash_completion.d/
	cp $TERMUX_PKG_SRCDIR/completions/bash/apt \
	   $TERMUX_PREFIX/etc/bash_completion.d/
}
