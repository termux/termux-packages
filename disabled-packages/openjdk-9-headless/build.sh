TERMUX_PKG_HOMEPAGE=http://openjdk.java.net
TERMUX_PKG_DESCRIPTION='OpenJDK 9 Java Runtime Environment (prerelease)'
_jbuild=158
_hg_tag="jdk-9+${_jbuild}"
TERMUX_PKG_VERSION="9b$_jbuild"
TERMUX_PKG_MAINTAINER='Vishal Biswas @vishalbiswas'
TERMUX_PKG_DEPENDS="freetype, alsa-lib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-hotspot-gtest
--disable-option-checking
--disable-warnings-as-errors
--enable-headless-only
--with-debug-level=release
--with-libffi-include=$TERMUX_PREFIX/include
--with-libffi-lib=$TERMUX_PREFIX/lib
--with-libpng=system
--with-zlib=system
"
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
		"https://github.com/apple/cups/releases/download/v$_cups_ver/cups-$_cups_ver-source.tar.gz")

	sha256sums=('d11fba6c6aea0d815bf37ec33b95a9eabf5cf6bd85c998d2a2945de610340a82'
		'6c38a48a9a4095604b0feeaacad7fec6337186631a1d11b27215ad3b3f0f4e96'
		'd646f5e0166b1877951540cac6b9eff6be130cb1324e5a63871104aad3b6d6f0'
		'773d4420b556baaad69b06434b6e21b488cf8df1f437b3b83ddbbbd32e906e83'
		'af5d86f1e2b4ac8773ee9e5cb799797c1e9c7e606a1618bfad0e4f7854b062d2'
		'3d1b96268c6b1fc35f69b4e62be32a0a1b4ef299f95f2139b0c57b982d792869'
		'94fb51401a4aa6387d0d35df4cba0d2e6560329ca842604be1752f8e4a253e33'
		'23afc54946898ffc51d1e22a40a078c69441bd1c8b4a99b7e84d471e6ca1f302'
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
		termux_download ${targzs[index]} $file $sum
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

