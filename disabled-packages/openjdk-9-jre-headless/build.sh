TERMUX_PKG_HOMEPAGE=http://openjdk.java.net
TERMUX_PKG_DESCRIPTION="OpenJDK 9 Java Runtime Environment (prerelease)"
_jbuild=162
_hg_tag="jdk-9+${_jbuild}"
_jvm_dir="lib/jvm/openjdk-9"
TERMUX_PKG_VERSION="9.2017.4.3"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_HOMEPAGE=http://openjdk.java.net/projects/jdk9
TERMUX_PKG_DEPENDS="freetype, libpng, ca-certificates-java"
TERMUX_PKG_CONFFILES="$_jvm_dir/lib/jvm.cfg"
# currently upstream has no support building for these arches on android
# this will change in the future
TERMUX_PKG_BLACKLISTED_ARCHES="aarch64 x86_64"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-hotspot-gtest
--disable-option-checking
--disable-warnings-as-errors
--enable-headless-only
--with-freetype=$TERMUX_PREFIX
--with-libpng=system
--with-zlib=system
--with-jdk-variant=normal
--with-jvm-variants=client
"
TERMUX_PKG_CLANG=no
TERMUX_PKG_RM_AFTER_INSTALL="$_jvm_dir/demo $_jvm_dir/sample"

_cups_ver=2.2.3

changesets=('d9c3e4f30936'
	'493011dee80e'
	'dc3346496843'
	'0d44d05a4c96'
	'3890f96e8995'
	'92a38c75cd27'
	'24582dd2649a'
	'5e5e436543da')

sha256sums=('36ca35e4fe90ae1b1966d9f909c108f39fe411b2e783faa49102d2088909be8e'
	'9d24cab2e16c17f51d591b9786005062bee3e60e394d1b78dddbdfb01b9a5ea6'
	'312204f76d4f23be09aa7121273ac791588de5c6a3c25d49b3087a6eb547bb7a'
	'9ef21b7013ef2a0b0870d4741fc961d1fce0fcb91f44a1f8cdad865455583246'
	'8d925111270630a171b0165b740bdd5d8d07c4aa1f9ea3caa86076b9f896d3ed'
	'1fec470e1480472ec7e4ff402bc4b6de5e095cfd5f787bdc250814eb9479a3c0'
	'db95a143078cdf3cefff5479c5350b678b1a779fcdcf7e066049559a537d81e1'
	'115601bbce2f5d9df66ce49d4ca6f6db327f1e17865537911160f0cde919e7bf'
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
}

termux_step_configure () {
	bash $TERMUX_PKG_SRCDIR/configure \
		--prefix=$TERMUX_PREFIX \
		--openjdk-target=$TERMUX_HOST_PLATFORM \
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
