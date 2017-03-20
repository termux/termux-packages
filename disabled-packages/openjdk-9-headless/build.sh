TERMUX_PKG_HOMEPAGE=http://openjdk.java.net
TERMUX_PKG_DESCRIPTION="OpenJDK 9 Java Runtime Environment (prerelease)"
_jbuild=160
_hg_tag="jdk-9+${_jbuild}"
TERMUX_PKG_VERSION="9.2017.3.20"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_HOMEPAGE=http://openjdk.java.net/projects/jdk9
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

changesets=('b273cb907f72'
	'18f02bc43fe9'
	'033d015c6d8b'
	'ac4c88ea156c'
	'7d5352c54fc8'
	'51b63f1b8001'
	'2340259b3155'
	'd6ef419af865')

sha256sums=('1fe425e4cade15bc552083b067270b1049a9ae2a4f721a48c55709cc593f1657'
	'1dff59f743f03a284caa70184873d24e9d3733485f15c9c3519843ea2986e0d7'
	'f417fce184e755b279d681819470f4a6f2d8ba6aa2624b520c67bfc184cb3ab2'
	'7de8fd296a1b9602851797d88268fae4fac171706bfeb80b20c352ff070ab60f'
	'efe917c6c776485069bfa147065e7ebfa9d7b3d937eec6db4f143b847548c0a2'
	'801261a2e65688264ba33fe50ef87bbf3ff703cb6b70d0661b365ca17d776b16'
	'a3961c7ff0e2f8c80f99e49e321dc0c2e15c752a90f6ff6b95d77f54e10e1650'
	'a4e817b9f2e66f46646b4043081aa8be8e6502221d85d1f606f5e808b0b23f2a'
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

