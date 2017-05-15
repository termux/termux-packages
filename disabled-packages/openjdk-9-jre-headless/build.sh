TERMUX_PKG_HOMEPAGE=http://openjdk.java.net
TERMUX_PKG_DESCRIPTION="OpenJDK 9 Java Runtime Environment (prerelease)"
_jbuild=168
_hg_tag="jdk-9+${_jbuild}"
_jvm_dir="lib/jvm/openjdk-9"
TERMUX_PKG_VERSION="9.2017.5.12"
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

changesets=('d3e4e68dc2a4'
	'b2218d41edef'
	'2982a1d6ecfc'
	'69b4c97b87b5'
	'912cf69806d5'
	'5d9d2a65fb26'
	'0e522ff8b9f5'
	'131e25008015')

sha256sums=('6e38d7ff3ae082206b43973fd43c07c88d1e5b30985e0c4d8357c364f51cf66c'
	'3173a9b6bc380ebdda014c512f0f88871a8ebdea3fda0d9ad350dba42a3493d6'
	'ff1342410d63ccec54f3e043b74fbc0549b01260bb15170515c68a8dfb4f7b0b'
	'cda559ee5cae0f8ab0c7ea19d70eaff58e7a44462786c78dfa8811f24d548aef'
	'a24208276b465e64085890d7daf5c4d25eb8abf629d636477f85e8849a7c978a'
	'a1b1a77118183000cf20bac7e10e7272145dc64e1120ccb4559b8df7160a48db'
	'3f4517e94efb689a291dce74ac2a12e496767d417a05d7fc6c74c483f3d14cca'
	'961adb3a0facfec181ff3b999b6fa079dffb1ff4a8f5607905f5ea28dcc597bf'
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
