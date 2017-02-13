TERMUX_PKG_HOMEPAGE=http://openjdk.java.net
TERMUX_PKG_DESCRIPTION='OpenJDK 9 Java Runtime Environment (prerelease)'
_jbuild=153
_hg_tag="jdk-9+${_jbuild}"
TERMUX_PKG_VERSION="9b$_jbuild"
TERMUX_PKG_MAINTAINER='Vishal Biswas @vishalbiswas'
TERMUX_PKG_DEPENDS="freetype, alsa-lib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --with-zlib=system --with-libpng=system --disable-option-checking --with-debug-level=release"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-headless-only --disable-warnings-as-errors --disable-hotspot-gtest --with-libffi-include=$TERMUX_PREFIX/include --with-libffi-lib=$TERMUX_PREFIX/lib"
TERMUX_PKG_CLANG=no
_cups_ver=2.2.2

termux_step_extract_package () {
	_url_src=http://hg.openjdk.java.net/jdk9/dev
	targzs=(${_url_src}/archive/$_hg_tag.tar.bz2
		${_url_src}/corba/archive/$_hg_tag.tar.bz2
		${_url_src}/hotspot/archive/$_hg_tag.tar.bz2
		${_url_src}/jdk/archive/$_hg_tag.tar.bz2
		${_url_src}/jaxws/archive/$_hg_tag.tar.bz2
		${_url_src}/jaxp/archive/$_hg_tag.tar.bz2
		${_url_src}/langtools/archive/$_hg_tag.tar.bz2
		${_url_src}/nashorn/archive/$_hg_tag.tar.bz2
		"https://github.com/apple/cups/releases/download/$_cups_ver/cups-$_cups_ver-source.tar.gz")

	sha256sums=('9e0748addf6214f6d2f008987978e70284054e5e0b9df5189e8f758d325c4972'
		'32522d53be8fc48f2cdaab56df9a387684af0e775501bbe19436e228779cc7c9'
		'7f92379fa40a621a1edc7e35792b07814ef755211b473ef87f1002c7a3c62699'
		'9f112b2af8dfea0dabf0371a0e5ede6e71485caab06f348ec7f7324db6d5e169'
		'636a6f119506d298571baf732aabb0fb459f8e3abf98788bcedc5bba4c7f06db'
		'8d51802aaf9d6f02d4414baecd164f6ccd64c25679e45a507139150294b0499c'
		'e4d0b9d8fc4f3d07b0a8f824bb2809a774dd6d5ae7e0db521082c885057a2c6b'
		'557f954271627289508542bfe0966132d51ec5ee79c9cad654a30a5c9c800ce1'
		'f589bb7d5d1dc3aa0915d7cf2b808571ef2e1530cd1a6ebe76ae8f9f4994e4f6')

	reponames=(dev corba hotspot jdk jaxws jaxp langtools nashorn cups)

	for index in "${!targzs[@]}"; do
		if [ $index != '8' ]; then
			filename=${reponames[index]}-`basename ${targzs[index]}`
			folder=`basename $filename .tar.bz2`
			folder=`echo $folder | sed 's/_/-/'`
		else
			filename=`basename ${targzs[index]}`
			folder="cups-$_cups_ver"
		fi
		sum=${sha256sums[index]}
		file=$TERMUX_PKG_CACHEDIR/$filename
		test ! -f $file && termux_download ${targzs[index]} $file $sum
		rm -Rf $folder
		$TERMUX_TAR xf $file
		mkdir -p $TERMUX_PKG_SRCDIR
		mv $folder $TERMUX_PKG_SRCDIR/
	done
}

termux_step_post_extract_package () {
	for patch in $TERMUX_PKG_BUILDER_DIR/*.diff; do
		sed "s%\@TAG_VER\@%${_jbuild}%g" "$patch" | \
                        patch --silent -p1
	done

	cd $TERMUX_PKG_SRCDIR/dev-$_hg_tag
        chmod a+x configure
        for subrepo in corba hotspot jdk jaxws jaxp langtools nashorn; do
                ln -s ../${subrepo}-$_hg_tag ${subrepo}
        done
        ln -s ../cups-$_cups_ver cups
}

termux_step_pre_configure () {
	TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/dev-$_hg_tag
	#export MAKEFLAGS=${MAKEFLAGS/-j*}
	#export CFLAGS+=" -Wno-error=deprecated-declarations -DSIGCLD=SIGCHLD"
	CFLAGS="$CFLAGS -I$TERMUX_PKG_BUILDER_DIR -I$TERMUX_PREFIX/include -DTERMUX_SHMEM_STUBS"
	CXXFLAGS="$CXXFLAGS -I$TERMUX_PKG_BUILDER_DIR -I$TERMUX_PREFIX/include"
	#LDFLAGS="$LDFLAGS -landroid-shmem"

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-cups-include=$TERMUX_PKG_SRCDIR/cups"
	TERMUX_JVM_VARIANT=zero
	if [ "$TERMUX_ARCH" == 'i686' -o "$TERMUX_ARCH" == 'x86_64' ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=' --with-jvm-variants=client'
		TERMUX_PKG_JVM_VARIANT=client
	else
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=' --with-jvm-variants=zero'
		TERMUX_PKG_JVM_VARIANT=zero
	fi

	cat > "$TERMUX_STANDALONE_TOOLCHAIN/devkit.info" <<HERE
DEVKIT_NAME="Android ${TERMUX_ARCH^^}"
DEVKIT_TOOLCHAIN_PATH="\$DEVKIT_ROOT/$TERMUX_HOST_PLATFORM/bin"
DEVKIT_SYSROOT="\$DEVKIT_ROOT/sysroot" i
HERE

	export ANDROID_DEVKIT=$TERMUX_STANDALONE_TOOLCHAIN

	cd $TERMUX_PKG_SRCDIR
}

termux_step_configure () {
	$TERMUX_PKG_SRCDIR/configure \
		--prefix=$TERMUX_PREFIX \
		--host=$TERMUX_HOST_PLATFORM \
		--target=$TERMUX_HOST_PLATFORM \
		--with-jdk-variant=normal \
		--libexecdir=$TERMUX_PREFIX/libexec \
		--with-devkit=$ANDROID_DEVKIT \
		--with-extra-cflags="$CFLAGS" \
		--with-extra-cxxflags="$CXXFLAGS" \
		--with-extra-ldflags="$LDFLAGS" \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

termux_step_make () {
	make JOBS=$TERMUX_MAKE_PROCESSES images
}

