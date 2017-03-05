TERMUX_PKG_HOMEPAGE=http://openjdk.java.net
TERMUX_PKG_DESCRIPTION='OpenJDK 9 Java Runtime Environment (prerelease)'
_jbuild=158
_hg_tag="jdk-9+${_jbuild}"
TERMUX_PKG_VERSION="9.2017.3.3"
TERMUX_PKG_MAINTAINER='Vishal Biswas @vishalbiswas'
TERMUX_PKG_DEPENDS="freetype, libpng, libffi"
# currently upstream has no support building for these arches on android
# this will change in the future
TERMUX_PKG_BLACKLISTED_ARCHES="aarch64 x86_64"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-hotspot-gtest
--disable-option-checking
--disable-warnings-as-errors
--enable-headless-only
--with-libffi=$TERMUX_PREFIX
--with-freetype=$TERMUX_PREFIX
--with-libpng=system
--with-zlib=system
"
TERMUX_PKG_CLANG=no
_cups_ver=2.2.2

changesets=('84493751ba37'
	'6feea77d2083'
	'95ce736479b8'
	'e45f1067d76b'
	'0ea34706c7fa'
	'5695854e8831'
	'39449d2a6398'
	'd75af059cff6')

sha256sums=('8dba157e41bd3ffcec681d2dfc3141951f19c0a19a68d1e2568b314d0978c018'
	'1a269f62e7e99b097fd7620c2ce995833336c1b79f03bd8a7af3f066f6099862'
	'2fff75a970c4ae21620ece45dcb4015ec13cdfd265ab1746503adf786922d200'
	'd58e2f4a7e8421a5f9396870d4a47f42dd41dfff1232e52add71410c75f35832'
	'dcb0efdf5e633396957c18c0c8b54531c44d8f6c24d03c3f87cc9b41ff633957'
	'7da207e287e6df85c955b5d7a45e7f747934dcaa15a12741d022c50ef89799e7'
	'90980cd581b426a51fa22d77cbcb68e5ddea4c048a282cf82ef438e5da0a7bf0'
	'f35e87e80ad01cec5d445e59d4b37ba55899651845081f76b6d56a348ca1ce97'
	'f589bb7d5d1dc3aa0915d7cf2b808571ef2e1530cd1a6ebe76ae8f9f4994e4f6')

reponames=(dev corba hotspot jdk jaxws jaxp langtools nashorn cups)

_url_src=http://hg.openjdk.java.net/mobile/dev

TERMUX_PKG_SRCURL=$_url_src/archive/${changesets[0]}.tar.bz2
TERMUX_PKG_SHA256=${sha256sums[0]}
TERMUX_PKG_FOLDERNAME=dev-${changesets[0]}

termux_step_post_extract_package () {
	cd "$TERMUX_PKG_TMPDIR"
	# download and extract repo archives
	for index in {1..7}; do
		local sum=${sha256sums[index]}
		local repo=${reponames[index]}
		local change=${changesets[index]}
		local file=$TERMUX_PKG_CACHEDIR/$repo-$change.tar.bz2
		local url=${_url_src}/$repo/archive/$change.tar.bz2

		termux_download $url $file $sum
		$TERMUX_TAR xf $file -C $TERMUX_PKG_SRCDIR
		mv $TERMUX_PKG_SRCDIR/$repo-$change $TERMUX_PKG_SRCDIR/$repo
	done

	# setup cups source dir
	file=$TERMUX_PKG_CACHEDIR/cups-$_cups_ver-source.tar.gz
	url="https://github.com/apple/cups/releases/download/v$_cups_ver/`basename $file`"
	termux_download $url $file ${sha256sums[8]}
	$TERMUX_TAR xf $file -C $TERMUX_PKG_SRCDIR
}

# override this step to since openjdk provides their own customized guess scripts
termux_step_replace_guess_scripts () {
	return
}

termux_step_pre_configure () {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-cups-include=$TERMUX_PKG_SRCDIR/cups-$_cups_ver"

	# might be required
	# libffi dependency is required if zero interpreter is used
	#if [ -o "$TERMUX_ARCH" == 'i686' -o "$TERMUX_ARCH" == 'x86_64' ]; then
	#	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=' --with-jvm-variants=client'
	#else
	#	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=' --with-jvm-variants=zero'
	#fi

	cat > "$TERMUX_STANDALONE_TOOLCHAIN/devkit.info" <<HERE
DEVKIT_NAME="Android ${TERMUX_ARCH^^}"
DEVKIT_TOOLCHAIN_PATH="\$DEVKIT_ROOT/$TERMUX_HOST_PLATFORM/bin"
DEVKIT_SYSROOT="\$DEVKIT_ROOT/sysroot"
HERE

	export ANDROID_DEVKIT=$TERMUX_STANDALONE_TOOLCHAIN

	if [ -n "$TERMUX_DEBUG" ]; then TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-debug-level=slowdebug"; fi
}

termux_step_configure () {
	bash $TERMUX_PKG_SRCDIR/configure \
		--prefix=$TERMUX_PREFIX \
		--openjdk-target=$TERMUX_HOST_PLATFORM \
		--with-jdk-variant=normal \
		--libexecdir=$TERMUX_PREFIX/libexec \
		--with-devkit=$ANDROID_DEVKIT \
		--with-extra-cflags="$CPPFLAGS $CFLAGS" \
		--with-extra-cxxflags="$CPPFLAGS $CXXFLAGS" \
		--with-extra-ldflags="$LDFLAGS" \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

termux_step_make () {
	make JOBS=$TERMUX_MAKE_PROCESSES images
}

