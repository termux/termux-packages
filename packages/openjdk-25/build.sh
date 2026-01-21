TERMUX_PKG_HOMEPAGE=https://openjdk.java.net
TERMUX_PKG_DESCRIPTION="Java development kit and runtime"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.0.2"
TERMUX_PKG_SRCURL=https://github.com/openjdk/jdk25u/archive/refs/tags/jdk-${TERMUX_PKG_VERSION}-ga.tar.gz
TERMUX_PKG_SHA256=e4b935e999a28ee732dfb932dcef4a8591b42f6fcd182099319db68e9d8017ff
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='25\.\d+\.\d+(?=-ga)'
TERMUX_PKG_DEPENDS="libandroid-shmem, libandroid-spawn, libiconv, libjpeg-turbo, zlib, littlecms, alsa-plugins"
TERMUX_PKG_BUILD_DEPENDS="cups, fontconfig, libxrandr, libxt, xorgproto, alsa-lib"
# openjdk-25-x is recommended because X11 separation is still very experimental.
TERMUX_PKG_RECOMMENDS="ca-certificates-java, openjdk-25-x, resolv-conf"
# openjdk no longer officially supports 32-bit x86
# technically, it has been manually force-tested by the author of the openjdk-25 Termux package,
# and it does still work superficially,
# but it hasn't been just lightly disabled, it has had 30,000 lines of code deleted and that's a huge patch
# that doesn't really belong in Termux, so upstream is clear that they don't want people to use it anymore.
# https://github.com/openjdk/jdk25u/commit/ee710fec21c4e886769576c17ad6db2ab91a84b4
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_SUGGESTS="cups"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HAS_DEBUG=false
TERMUX_PKG_HOSTBUILD=true
# enable lto
__jvm_features="link-time-opt"

termux_step_host_build() {
	# precompiled JDK release for GNU/Linux to use as host JDK for bootstrapping
	# does not need to exactly match the TERMUX_PKG_VERSION
	JDK_BINURL="https://download.java.net/java/GA/jdk25/bd75d5f9689641da8e1daabeccb5528b/36/GPL/openjdk-25_linux-x64_bin.tar.gz"
	JDK_BINARCHIVE="${TERMUX_PKG_CACHEDIR}/openjdk-25_linux-x64_bin.tar.gz"
	JDK_BINSHA256=59cdcaf255add4721de38eb411d4ecfe779356b61fb671aee63c7dec78054c2b
	termux_download "$JDK_BINURL" "$JDK_BINARCHIVE" "$JDK_BINSHA256"
	tar -xf "$JDK_BINARCHIVE" --strip-components=1 -C "$TERMUX_PKG_HOSTBUILD_DIR"
}

termux_step_pre_configure() {
	unset JAVA_HOME

	local patch="$TERMUX_PKG_BUILDER_DIR/tmpdir-path-length.diff"
	local tmpdir_path="$TERMUX_PREFIX/tmp"
	echo "Applying patch: $(basename "$patch")"
	test -f "$patch" && sed \
		-e "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
		-e "s%\@TERMUX_TMPDIR_PATH_LENGTH\@%${#tmpdir_path}%g" \
		"$patch" | patch --silent -p1

	# g1gc causes 'Illegal instruction' on 32-bit ARM after
	# https://github.com/openjdk/jdk24u/commit/0b467e902d591ae9feeec1669918d1588987cd1c
	# and LTO causes 'Segmentation fault' on 32-bit ARM after
	# https://github.com/openjdk/jdk24u/commit/85fedbf668023fd00d70ec649504c2f80e4c84bb
	# (disabling both commits is necessary,
	# if either one is disabled alone, respective crash still happens)
	if [[ "$TERMUX_ARCH" == "arm" ]]; then
		__jvm_features="-g1gc,-link-time-opt"
	fi
}

termux_step_configure() {
	local jdk_ldflags="-L${TERMUX_PREFIX}/lib \
		-Wl,-rpath=$TERMUX_PREFIX/lib/jvm/java-25-openjdk/lib \
		-Wl,-rpath=${TERMUX_PREFIX}/lib -Wl,--enable-new-dtags"
	bash ./configure \
		--with-boot-jdk="$TERMUX_PKG_HOSTBUILD_DIR" \
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
		--with-extra-ldflags="${jdk_ldflags} -Wl,--as-needed -landroid-shmem -landroid-spawn" \
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
	rm -rf  $TERMUX_PREFIX/lib/jvm/java-25-openjdk
	mkdir -p $TERMUX_PREFIX/lib/jvm/java-25-openjdk
	cp -r build/linux-${TERMUX_ARCH/i686/x86}-server-release/images/jdk/* \
		$TERMUX_PREFIX/lib/jvm/java-25-openjdk/
	find $TERMUX_PREFIX/lib/jvm/java-25-openjdk/ -name "*.debuginfo" -delete

	# Dependent projects may need JAVA_HOME.
	mkdir -p $TERMUX_PREFIX/lib/jvm/java-25-openjdk/etc/profile.d
	echo "export JAVA_HOME=$TERMUX_PREFIX/lib/jvm/java-25-openjdk/" > \
		$TERMUX_PREFIX/lib/jvm/java-25-openjdk/etc/profile.d/java.sh
}

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/lib/jvm/java-25-openjdk/man/man1
	for manpage in *.1; do
		gzip "$manpage"
	done

	# Make sure that our alternatives file is up to date.
	binaries="$(find $TERMUX_PREFIX/lib/jvm/java-25-openjdk/bin -executable -type f | xargs -I{} basename "{}" | xargs echo)"
	manpages="$(find $TERMUX_PREFIX/lib/jvm/java-25-openjdk/man/man1 -name "*.1.gz" | xargs -I{} basename "{}" | xargs echo)"

	local failure=false
	for binary in $binaries; do
		grep -q "lib/jvm/java-25-openjdk/bin/${binary}$" "$TERMUX_PKG_BUILDER_DIR"/openjdk-25.alternatives || {
			echo "ERROR: Missing entry for binary: $binary in openjdk-25.alternatives"
			failure=true
		}
	done

	for manpage in $manpages; do
		grep -q "lib/jvm/java-25-openjdk/man/man1/${manpage}$" "$TERMUX_PKG_BUILDER_DIR"/openjdk-25.alternatives || {
			echo "ERROR: Missing entry for manpage: $manpage in openjdk-25.alternatives"
			failure=true
		}
	done
	if [[ "$failure" = true ]]; then
		termux_error_exit "ERROR: openjdk-25.alternatives is not up to date, please update it."
	fi
}
