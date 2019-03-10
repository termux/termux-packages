TERMUX_PKG_HOMEPAGE=http://openjdk.java.net
TERMUX_PKG_DESCRIPTION="OpenJDK 9 Java Runtime Environment (prerelease)"
_jbuild=181
_hg_tag="jdk-9+${_jbuild}"
_jvm_dir="lib/jvm/openjdk-9"
TERMUX_PKG_VERSION="9.2017.8.20"
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
TERMUX_PKG_RM_AFTER_INSTALL="$_jvm_dir/demo $_jvm_dir/sample"
_cups_ver=2.2.4

changesets=('e5455438db96'
	'5666eba44ac6'
	'8076a7391ba0'
	'17bb8a98d5e3'
	'a1d64f45f9d5'
	'364631d8ff2e'
	'65bfdabaab9c'
	'17cc754c8936')

sha256sums=('c759faa5bff4b3d7bcf87dce57e9d1a39600ef67ec68f96d6d12d07b1bf773ce'
	'34518bf8b27aa893f834f8f81293ac0e04a210ee4f2e11bb2c89331f87912d96'
	'3b649e34e2a1c8758c6311931d201a38432088ccb86a720afb1cb99fe193537f'
	'bb330b8b516178304dc11c755994db20eccc696ae5c2a16b04a4a67b20b33b79'
	'a213ebc4bf896c55855761891932a19f42ad5276d3fd155cfb604b27f4866d9d'
	'0bc1953e9f23d59dafc415a7a37ff2da23cf8782e0532e253a6d7d63aa0ea954'
	'739a5d275db4a2a81cf3c3ca17a78212b8c47092e5c10888b79e9599dd9dcc2d'
	'fbc9b49a7f0fa1723e369d91068d51a11de40e931f281a3ed9650484b437cc7f'
	'596d4db72651c335469ae5f37b0da72ac9f97d73e30838d787065f559dea98cc')

reponames=(dev corba hotspot jdk jaxws jaxp langtools nashorn cups)

_url_src=http://hg.openjdk.java.net/mobile/dev

TERMUX_PKG_SRCURL=$_url_src/archive/${changesets[0]}.tar.bz2
TERMUX_PKG_SHA256=${sha256sums[0]}

termux_step_post_extract_package() {
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
	url="https://github.com/apple/cups/releases/download/v$_cups_ver/$(basename $file)"
	termux_download $url $file ${sha256sums[8]}
	tar xf $file -C $TERMUX_PKG_SRCDIR
}

# override this step to since openjdk provides its own customized guess scripts
termux_step_replace_guess_scripts() {
	return
}

termux_step_pre_configure() {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-cups-include=$TERMUX_PKG_SRCDIR/cups-$_cups_ver"

	ln -sf $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/libc.so $TERMUX_PKG_TMPDIR/libpthread.so

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
termux_step_configure() {
	if [ $TERMUX_ARCH = "x86_64" ]; then
	ln -sf $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib64/libc.so $TERMUX_PKG_TMPDIR/libpthread.so
	else
	ln -sf $TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/libc.so $TERMUX_PKG_TMPDIR/libpthread.so
	fi
	ARM64=""
	if [ $TERMUX_ARCH = aarch64 ]; then
		    export  ARM64=" --with-cpu-port=arm64"
	fi

	bash $TERMUX_PKG_SRCDIR/configure \
		$ARM64 \
		--prefix=$TERMUX_PREFIX \
		--openjdk-target=$BUILD_TRIPLE \
		--libexecdir=$TERMUX_PREFIX/libexec \
		--with-devkit=$ANDROID_DEVKIT \
		--with-extra-cflags="$CPPFLAGS $CFLAGS" \
		--with-extra-cxxflags="$CPPFLAGS $CXXFLAGS" \
		--with-extra-ldflags="-L$TERMUX_PKG_TMPDIR  $LDFLAGS -ldl" \
		--with-jvm-features="$JVM_FEATURES" \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

termux_step_make() {
	make JOBS=$TERMUX_MAKE_PROCESSES images
}

termux_step_post_make_install() {
	# move jvm install dir
	mkdir -p $TERMUX_PREFIX/lib/jvm
	rm -rf "$TERMUX_PREFIX/lib/jvm/openjdk-9"
	mv $TERMUX_PREFIX/jvm/openjdk-9-internal $TERMUX_PREFIX/$_jvm_dir

	# place src.zip in standard location mimicking ubuntu
	mv $TERMUX_PREFIX/$_jvm_dir/lib/src.zip $TERMUX_PREFIX/$_jvm_dir/src.zip

	# create shell wrappers for binaries
	for binary in $TERMUX_PREFIX/$_jvm_dir/bin/*; do
		binary=$(basename $binary)
		rm -f $TERMUX_PREFIX/bin/$binary
		echo "export JAVA_HOME=\$PREFIX/$_jvm_dir" > $TERMUX_PREFIX/bin/$binary
		echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$JAVA_HOME/lib:\$JAVA_HOME/lib/jli" >> $TERMUX_PREFIX/bin/$binary
		echo "exec \$JAVA_HOME/bin/$binary \"\$@\"" >> $TERMUX_PREFIX/bin/$binary
		chmod u+x $TERMUX_PREFIX/bin/$binary
	done

	# use cacerts provided by ca-certificates-java
	ln -sf "$TERMUX_PREFIX/$_jvm_dir/lib/security/jssecacerts" "$TERMUX_PREFIX/$_jvm_dir/lib/security/cacerts"
}
