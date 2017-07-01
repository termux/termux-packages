TERMUX_PKG_HOMEPAGE=http://openjdk.java.net
TERMUX_PKG_DESCRIPTION="OpenJDK 9 Java Runtime Environment (prerelease)"
_jbuild=174
_hg_tag="jdk-9+${_jbuild}"
_jvm_dir="lib/jvm/openjdk-9"
TERMUX_PKG_VERSION="9.2017.6.24"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_HOMEPAGE=http://openjdk.java.net/projects/jdk9
TERMUX_PKG_DEPENDS="freetype, libpng, ca-certificates-java"
TERMUX_PKG_CONFFILES="$_jvm_dir/lib/jvm.cfg"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-aot
--disable-hotspot-gtest
--disable-option-checking
--disable-warnings-as-errors
--enable-headless-only
--with-freetype=$TERMUX_PREFIX
--with-libpng=system
--with-zlib=system
--with-jdk-variant=normal
--with-jvm-variants=server
"
TERMUX_PKG_CLANG=no
TERMUX_PKG_RM_AFTER_INSTALL="$_jvm_dir/demo $_jvm_dir/sample"
_cups_ver=2.2.3

changesets=('b0ac0fef5b92'
	'dc78a3dd6b3a'
	'a81769cc0015'
	'ee95c24502f3'
	'a5d361b9d1f7'
	'736412a8dcce'
	'83f6eb009d8f'
	'734b3209b6ed')

sha256sums=('b269c630374c181840c126f8e82cd799147b556482cad3231c577741d0718373'
	'7da8245591a3ea3c6c7d0aea6cd2c653e0039a2ea5511ff2cea988223b02c388'
	'021b9b8f943087fc7967fe3640d68ab989b791ed1133966a402e1b49f4c6154e'
	'77200280da08f56dd298a748b99a8107dddd113872d619677e0a02eeee88bc84'
	'435d2e98df810ce45c36af511acbf8cf9b19c68371f9692e95c6aeef2b8fd473'
	'43a89436e6f9c11939c7d93a4daa748bc3155e8f1d6fc6e6507310b3addf31a2'
	'c8341d99f315575a11d1f33b243f4cbdab25240caf53668eea8e09a9ecfaf2c5'
	'52eeb4ea0c77054f7abb847f9798cedf653ac50de56a6e2d69b7277822738314'
	'66701fe15838f2c892052c913bde1ba106bbee2e0a953c955a62ecacce76885f')

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
		tar xf $file -C $TERMUX_PKG_SRCDIR
		mv $TERMUX_PKG_SRCDIR/$repo-$change $TERMUX_PKG_SRCDIR/$repo
	done

	# setup cups source dir
	file=$TERMUX_PKG_CACHEDIR/cups-$_cups_ver-source.tar.gz
	url="https://github.com/apple/cups/releases/download/v$_cups_ver/`basename $file`"
	termux_download $url $file ${sha256sums[8]}
	tar xf $file -C $TERMUX_PKG_SRCDIR
}

# override this step to since openjdk provides its own customized guess scripts
termux_step_replace_guess_scripts () {
	return
}

termux_step_pre_configure () {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-cups-include=$TERMUX_PKG_SRCDIR/cups-$_cups_ver"

	cat > "$TERMUX_STANDALONE_TOOLCHAIN/devkit.info" <<HERE
DEVKIT_NAME="Android ${TERMUX_ARCH^^}"
DEVKIT_TOOLCHAIN_PATH="\$DEVKIT_ROOT/$TERMUX_HOST_PLATFORM/bin"
DEVKIT_SYSROOT="\$DEVKIT_ROOT/sysroot"
HERE

	export ANDROID_DEVKIT=$TERMUX_STANDALONE_TOOLCHAIN

	if [ -n "$TERMUX_DEBUG" ]; then TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-debug-level=slowdebug"; fi
	BUILD_TRIPLE=$TERMUX_ARCH-linux-gnu
	test "$TERMUX_ARCH" == "arm" && BUILD_TRIPLE+="eabi"

	JVM_FEATURES="compiler1,compiler2,jvmti,fprof,vm-structs,jni-check,services,management,all-gcs,nmt,cds"
	# enable features specific to some arches
	if [ "$TERMUX_ARCH" == "aarch64" ] || [ "$TERMUX_ARCH" == "x86_64" ]; then JVM_FEATURES+=",jvmci,graal"; fi

	test "$TERMUX_ARCH" == "aarch64" && CFLAGS="$CFLAGS -DUSE_LIBRARY_BASED_TLS_ONLY"

	# remove sa_proc support
	rm $TERMUX_PKG_SRCDIR/hotspot/make/lib/Lib-jdk.hotspot.agent.gmk
}

termux_step_configure () {
	bash $TERMUX_PKG_SRCDIR/configure \
		--prefix=$TERMUX_PREFIX \
		--openjdk-target=$BUILD_TRIPLE \
		--libexecdir=$TERMUX_PREFIX/libexec \
		--with-devkit=$ANDROID_DEVKIT \
		--with-extra-cflags="$CPPFLAGS $CFLAGS" \
		--with-extra-cxxflags="$CPPFLAGS $CXXFLAGS" \
		--with-extra-ldflags="$LDFLAGS" \
		--with-jvm-features="$JVM_FEATURES" \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

termux_step_make () {
	make JOBS=$TERMUX_MAKE_PROCESSES images
}

termux_step_post_make_install () {
	# move jvm install dir
	mkdir -p $TERMUX_PREFIX/lib/jvm
	rm -rf "$TERMUX_PREFIX/lib/jvm/openjdk-9"
	mv $TERMUX_PREFIX/jvm/openjdk-9-internal $TERMUX_PREFIX/$_jvm_dir

	# place src.zip in standard location mimicking ubuntu
	mv $TERMUX_PREFIX/$_jvm_dir/lib/src.zip $TERMUX_PREFIX/$_jvm_dir/src.zip

	# create shell wrappers for binaries
	for binary in $TERMUX_PREFIX/$_jvm_dir/bin/*; do
		binary=`basename $binary`
		rm -f $TERMUX_PREFIX/bin/$binary
		echo "export JAVA_HOME=\$PREFIX/$_jvm_dir" > $TERMUX_PREFIX/bin/$binary
		echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$JAVA_HOME/lib:\$JAVA_HOME/lib/jli" >> $TERMUX_PREFIX/bin/$binary
		echo "\$JAVA_HOME/bin/$binary \"\$@\"" >> $TERMUX_PREFIX/bin/$binary
		chmod u+x $TERMUX_PREFIX/bin/$binary
	done

	# use cacerts provided by ca-certificates-java
	ln -sf "$TERMUX_PREFIX/$_jvm_dir/lib/security/jssecacerts" "$TERMUX_PREFIX/$_jvm_dir/lib/security/cacerts"
}
