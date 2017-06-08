TERMUX_PKG_HOMEPAGE=http://openjdk.java.net
TERMUX_PKG_DESCRIPTION="OpenJDK 9 Java Runtime Environment (prerelease)"
_jbuild=172
_hg_tag="jdk-9+${_jbuild}"
_jvm_dir="lib/jvm/openjdk-9"
TERMUX_PKG_VERSION="9.2017.6.8"
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

changesets=('6594f2b3be39'
	'534ba4f8cfcf'
	'af723e2723f9'
	'3688a3b35a2b'
	'2bd967aa452c'
	'9788347e0629'
	'123eb0956a45'
	'fa8e4de50e82')

sha256sums=('5292ed549c7af316b19c938d28518b0c6d96b746c2b055d26fef415d70bd460c'
	'b46f040128b9ac2bd743c5ccafef8093c8ffe758ae975e18d8107972a4b49733'
	'f9826651929da81039185da0dc9ccf4307fd4f04b2ce50f7fde0ed4bd92ba47b'
	'4e28aff89f8d537b8281c75ad3ecaa50327c7d8c20d2bdc9c6b7f83317768883'
	'd269dbd3f52a60b3a199daeeee383ea165694d6c9dead02de9cdffced9137a67'
	'fb217c5bab24c58d615c25942a3630b8f43428317af922df14bce0eb496988cf'
	'92856a4ad8ad8ce9a8cb1088b3c28bf57cc3e9e6a17df5ef52b7727cd576981a'
	'34a8536b47ed47a5b29de9b3f22ae8af3ffa0dabda22caeae1b84a2d83803a2b'
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
