TERMUX_PKG_HOMEPAGE=https://www.perl.org/
TERMUX_PKG_DESCRIPTION="Capable, feature-rich programming language"
TERMUX_PKG_LICENSE="Artistic-License-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Packages which should be rebuilt after version change:
# - exiftool
# - irssi
# - libapt-pkg-perl
# - libregexp-assemble-perl
# - psutils
# - subversion
TERMUX_PKG_VERSION=(5.34.0
                    1.3.6)
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=(551efc818b968b05216024fb0b727ef2ad4c100f8cb6b43fab615fa78ae5be9a
                   4010f41870d64e3957b4b8ce70ebba10a7c4a3e86c5551acb4099c3fcbb37ce5)
TERMUX_PKG_SRCURL=(http://www.cpan.org/src/5.0/perl-${TERMUX_PKG_VERSION}.tar.gz
		   https://github.com/arsv/perl-cross/releases/download/${TERMUX_PKG_VERSION[1]}/perl-cross-${TERMUX_PKG_VERSION[1]}.tar.gz)
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_MAKE_PROCESSES=1
TERMUX_PKG_RM_AFTER_INSTALL="bin/perl${TERMUX_PKG_VERSION}"

termux_step_post_get_source() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	# This port uses perl-cross: http://arsv.github.io/perl-cross/
	cp -rf perl-cross-${TERMUX_PKG_VERSION[1]}/* .

	# Remove old installation to force fresh:
	rm -rf $TERMUX_PREFIX/lib/perl5
	rm -f $TERMUX_PREFIX/lib/libperl.so
	rm -f $TERMUX_PREFIX/include/perl
}

termux_step_configure() {
	export PATH=$PATH:$TERMUX_STANDALONE_TOOLCHAIN/bin

	ORIG_AR=$AR; unset AR
	ORIG_AS=$AS; unset AS
	ORIG_CC=$CC; unset CC
	ORIG_CXX=$CXX; unset CXX
	ORIG_CPP=$CPP; unset CPP
	ORIG_CFLAGS=$CFLAGS; unset CFLAGS
	ORIG_CPPFLAGS=$CPPFLAGS; unset CPPFLAGS
	ORIG_CXXFLAGS=$CXXFLAGS; unset CXXFLAGS
	ORIG_LDFLAGS=$LDFLAGS; unset LDFLAGS
	ORIG_RANLIB=$RANLIB; unset RANLIB
	ORIG_LD=$LD; unset LD

	# Since we specify $TERMUX_PREFIX/bin/sh below for the shell
	# it will be run during the build, so temporarily (removed in
	# termux_step_post_make_install below) setup symlink:
	rm -f $TERMUX_PREFIX/bin/sh
	ln -s /bin/sh $TERMUX_PREFIX/bin/sh

	cd $TERMUX_PKG_BUILDDIR
	$TERMUX_PKG_SRCDIR/configure \
		--target=$TERMUX_HOST_PLATFORM \
		-Dosname=android \
		-Dsysroot=$TERMUX_STANDALONE_TOOLCHAIN/sysroot \
		-Dprefix=$TERMUX_PREFIX \
		-Dsh=$TERMUX_PREFIX/bin/sh \
		-Dcc="$ORIG_CC" \
		-Dld="$ORIG_CC -Wl,-rpath=$TERMUX_PREFIX/lib -Wl,--enable-new-dtags" \
		-Dar="$ORIG_AR" \
		-Duseshrplib
}

termux_step_post_make_install() {
	# Replace hardlinks with symlinks:
	cd $TERMUX_PREFIX/share/man/man1
	rm perlbug.1
	ln -s perlthanks.1 perlbug.1

	# Cleanup:
	rm $TERMUX_PREFIX/bin/sh

	cd $TERMUX_PREFIX/lib
	ln -f -s perl5/${TERMUX_PKG_VERSION}/${TERMUX_ARCH}-android/CORE/libperl.so libperl.so

	cd $TERMUX_PREFIX/include
	ln -f -s ../lib/perl5/${TERMUX_PKG_VERSION}/${TERMUX_ARCH}-android/CORE perl
	cd ../lib/perl5/${TERMUX_PKG_VERSION}/${TERMUX_ARCH}-android/
	chmod +w Config_heavy.pl
	sed 's',"--sysroot=$TERMUX_STANDALONE_TOOLCHAIN"/sysroot,"-I${TERMUX_PREFIX}/include",'g' Config_heavy.pl > Config_heavy.pl.new
	sed 's',"$TERMUX_STANDALONE_TOOLCHAIN"/sysroot,"-I${TERMUX_PREFIX%%/usr}",'g' Config_heavy.pl.new > Config_heavy.pl
	rm Config_heavy.pl.new

	# arm (and i686?) seem to explicitly need -pie set to be able
	# to install some perl packages.
	if [ "$TERMUX_ARCH" == "arm" ] || [ "$TERMUX_ARCH" == "i686" ]; then
		sed -i "s@cc => '$ORIG_CC',@cc => '$ORIG_CC -pie',@g" Config.pm
	fi
}
