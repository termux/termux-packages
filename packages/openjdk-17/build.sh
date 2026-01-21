TERMUX_PKG_HOMEPAGE=https://openjdk.java.net
TERMUX_PKG_DESCRIPTION="Java development kit and runtime"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="17.0.18"
TERMUX_PKG_SRCURL=https://github.com/openjdk/jdk17u/archive/refs/tags/jdk-${TERMUX_PKG_VERSION}-ga.tar.gz
TERMUX_PKG_SHA256=15c4fbd1d69254d362c24e82f4e9ab7ed69c8ebc7daf996500210698c944230a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='17\.\d+\.\d+(?=-ga)'
TERMUX_PKG_DEPENDS="libandroid-shmem, libandroid-spawn, libiconv, libjpeg-turbo, zlib, littlecms, alsa-plugins"
TERMUX_PKG_BUILD_DEPENDS="cups, fontconfig, libxrandr, libxt, xorgproto, alsa-lib"
# openjdk-17-x is recommended because X11 separation is still very experimental.
TERMUX_PKG_RECOMMENDS="ca-certificates-java, openjdk-17-x, resolv-conf"
TERMUX_PKG_SUGGESTS="cups"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HAS_DEBUG=false
# enable lto, but do not explicitly enable zgc or shenandoahgc because they
# are automatically enabled for x86, but are not supported for arm.
__jvm_features="link-time-opt"

termux_step_pre_configure() {
	unset JAVA_HOME

	local patch="$TERMUX_PKG_BUILDER_DIR/tmpdir-path-length.diff"
	local tmpdir_path="$TERMUX_PREFIX/tmp"
	echo "Applying patch: $(basename "$patch")"
	test -f "$patch" && sed \
		-e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
		-e "s%\@TERMUX_TMPDIR_PATH_LENGTH\@%${#tmpdir_path}%g" \
		"$patch" | patch --silent -p1
}

termux_step_configure() {
	local jdk_ldflags="-L${TERMUX_PREFIX}/lib \
		-Wl,-rpath=$TERMUX_PREFIX/lib/jvm/java-17-openjdk/lib \
		-Wl,-rpath=${TERMUX_PREFIX}/lib -Wl,--enable-new-dtags"
	bash ./configure \
		--disable-precompiled-headers \
		--disable-warnings-as-errors \
		--enable-option-checking=fatal \
		--with-version-pre="" \
		--with-version-opt="" \
		--with-jvm-variants=server \
		--with-jvm-features="${__jvm_features}" \
		--with-debug-level=release \
		--openjdk-target=$TERMUX_HOST_PLATFORM \
		--with-toolchain-type=clang \
		--with-extra-cflags="$CFLAGS $CPPFLAGS -DLE_STANDALONE -D__ANDROID__=1 -D__TERMUX__=1" \
		--with-extra-cxxflags="$CXXFLAGS $CPPFLAGS -DLE_STANDALONE -D__ANDROID__=1 -D__TERMUX__=1" \
		--with-extra-ldflags="${jdk_ldflags} -Wl,--as-needed -landroid-shmem -landroid-spawn -liconv" \
		--with-cups-include="$TERMUX_PREFIX/include" \
		--with-fontconfig-include="$TERMUX_PREFIX/include" \
		--with-freetype-include="$TERMUX_PREFIX/include/freetype2" \
		--with-freetype-lib="$TERMUX_PREFIX/lib" \
		--with-alsa="$TERMUX_PREFIX" \
		--with-alsa-include="$TERMUX_PREFIX/include/alsa" \
		--with-alsa-lib="$TERMUX_PREFIX/lib" \
		--with-x="$TERMUX_PREFIX/include/X11" \
		--x-includes="$TERMUX_PREFIX/include/X11" \
		--x-libraries="$TERMUX_PREFIX/lib" \
		--with-giflib=system \
		--with-lcms=system \
		--with-libjpeg=system \
		--with-libpng=system \
		--with-zlib=system \
		--with-vendor-name="Termux" \
		AR="$AR" \
		NM="$NM" \
		OBJCOPY="$OBJCOPY" \
		OBJDUMP="$OBJDUMP" \
		STRIP="$STRIP" \
		CXXFILT="llvm-cxxfilt" \
		BUILD_CC="$TERMUX_HOST_LLVM_BASE_DIR/bin/clang" \
		BUILD_CXX="$TERMUX_HOST_LLVM_BASE_DIR/bin/clang++" \
		BUILD_NM="$TERMUX_HOST_LLVM_BASE_DIR/bin/llvm-nm" \
		BUILD_AR="$TERMUX_HOST_LLVM_BASE_DIR/bin/llvm-ar" \
		BUILD_OBJCOPY="$TERMUX_HOST_LLVM_BASE_DIR/bin/llvm-objcopy" \
		BUILD_STRIP="$TERMUX_HOST_LLVM_BASE_DIR/bin/llvm-strip" \
		--with-jobs=$TERMUX_PKG_MAKE_PROCESSES
}

termux_step_make() {
	cd build/linux-${TERMUX_ARCH/i686/x86}-server-release
	make images
}

termux_step_make_install() {
	rm -rf $TERMUX_PREFIX/lib/jvm/java-17-openjdk
	mkdir -p $TERMUX_PREFIX/lib/jvm/java-17-openjdk
	cp -r build/linux-${TERMUX_ARCH/i686/x86}-server-release/images/jdk/* \
		$TERMUX_PREFIX/lib/jvm/java-17-openjdk/
	find $TERMUX_PREFIX/lib/jvm/java-17-openjdk/ -name "*.debuginfo" -delete

	# Dependent projects may need JAVA_HOME.
	mkdir -p $TERMUX_PREFIX/lib/jvm/java-17-openjdk/etc/profile.d
	echo "export JAVA_HOME=$TERMUX_PREFIX/lib/jvm/java-17-openjdk/" > \
		$TERMUX_PREFIX/lib/jvm/java-17-openjdk/etc/profile.d/java.sh
}

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/lib/jvm/java-17-openjdk/man/man1
	for manpage in *.1; do
		gzip "$manpage"
	done

	# Make sure that our alternatives file is up to date.
	binaries="$(find $TERMUX_PREFIX/lib/jvm/java-17-openjdk/bin -executable -type f | xargs -I{} basename "{}" | xargs echo)"
	manpages="$(find $TERMUX_PREFIX/lib/jvm/java-17-openjdk/man/man1 -name "*.1.gz" | xargs -I{} basename "{}" | xargs echo)"

	local failure=false
	for binary in $binaries; do
		grep -q "lib/jvm/java-17-openjdk/bin/${binary}$" "$TERMUX_PKG_BUILDER_DIR"/openjdk-17.alternatives || {
			echo "ERROR: Missing entry for binary: $binary in openjdk-17.alternatives"
			failure=true
		}
	done
	for manpage in $manpages; do
		grep -q "lib/jvm/java-17-openjdk/man/man1/${manpage}$" "$TERMUX_PKG_BUILDER_DIR"/openjdk-17.alternatives || {
			echo "ERROR: Missing entry for manpage: $manpage in openjdk-17.alternatives"
			failure=true
		}
	done
	if [[ "$failure" = true ]]; then
		termux_error_exit "openjdk-17.alternatives is not up to date, please update it."
	fi
}

termux_step_create_debscripts() {
	# For older versions of openjdk-17 and openjdk-21, we used to provide different alternatives for each binary and manpage.
	# This script removes those alternatives if the user is upgrading from an older version.
	#
	# Using slaves for all binaries and manpages makes it much easier to switch between different versions of openjdk.
	local old_alternatives=(
		java-profile
		jar
		jarsigner
		java
		javac
		javadoc
		javap
		jcmd
		jconsole
		jdb
		jdeprscan
		jdeps
		jfr
		jhsdb
		jimage
		jinfo
		jlink
		jmap
		jmod
		jpackage
		jps
		jrunscript
		jshell
		jstack
		jstat
		jstatd
		jwebserver
		keytool
		rmiregistry
		serialver
		jar.1.gz
		jarsigner.1.gz
		java.1.gz
		javac.1.gz
		javadoc.1.gz
		javap.1.gz
		jcmd.1.gz
		jconsole.1.gz
		jdb.1.gz
		jdeprscan.1.gz
		jdeps.1.gz
		jfr.1.gz
		jhsdb.1.gz
		jinfo.1.gz
		jlink.1.gz
		jmap.1.gz
		jmod.1.gz
		jpackage.1.gz
		jps.1.gz
		jrunscript.1.gz
		jshell.1.gz
		jstack.1.gz
		jstat.1.gz
		jstatd.1.gz
		jwebserver.1.gz
		keytool.1.gz
		rmiregistry.1.gz
		serialver.1.gz
	)
	# For older versions
	echo 'if [ "$#" = "3" ] && dpkg --compare-versions "$2" le "17.0.15-1"; then' > ./preinst
	echo '  echo "Removing older alternatives for openjdk-21 and openjdk-17"' >> ./preinst
	echo '  echo "This may take a while if mandoc package is installed, please wait..."' >> ./preinst
	echo '  echo "Newer versions of openjdk-21 and openjdk-17 change how alternatives are handled."' >> ./preinst
	echo '  echo "Instead of having different alternatives for each manpage and binary, now you can switch java versions much easily using \"update-alternatives --config java\""' >> ./preinst
	echo '  echo "This should switch all java binaries, manpages, and bash profile for java in a single command instead of switching everything manually"' >> ./preinst
	for alternative in "${old_alternatives[@]}"; do
		echo "  update-alternatives --remove-all ${alternative} || :" >> ./preinst
	done
	echo 'fi' >> ./preinst
}
