TERMUX_PKG_HOMEPAGE=https://openjdk.java.net
TERMUX_PKG_DESCRIPTION="Java development kit and runtime"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=21.0.3+6
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://github.com/openjdk/jdk21u/archive/refs/tags/jdk-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=75a6ca52299ee2f5b028a5a4acedd6139ae740cbf1af034e2d50489e74598dd3
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libandroid-shmem, libandroid-spawn, libiconv, libjpeg-turbo, zlib"
TERMUX_PKG_BUILD_DEPENDS="cups, fontconfig, libxrandr, libxt, xorgproto"
# openjdk-21-x is recommended because X11 separation is still very experimental.
TERMUX_PKG_RECOMMENDS="ca-certificates-java, openjdk-21-x, resolv-conf"
TERMUX_PKG_SUGGESTS="cups"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HAS_DEBUG=false

termux_step_pre_configure() {
	unset JAVA_HOME
}

termux_step_configure() {
	local jdk_ldflags="-L${TERMUX_PREFIX}/lib -Wl,-rpath=$TERMUX_PREFIX/lib/jvm/java-21-openjdk/lib -Wl,-rpath=${TERMUX_PREFIX}/lib -Wl,--enable-new-dtags"
	bash ./configure \
		--disable-precompiled-headers \
		--disable-warnings-as-errors \
		--enable-option-checking=fatal \
		--openjdk-target=$TERMUX_HOST_PLATFORM \
		--with-cups-include="$TERMUX_PREFIX/include" \
		--with-debug-level=release \
		--with-extra-cflags="$CFLAGS $CPPFLAGS -DLE_STANDALONE -D__ANDROID__=1 -D__TERMUX__=1" \
		--with-extra-cxxflags="$CXXFLAGS $CPPFLAGS -DLE_STANDALONE -D__ANDROID__=1 -D__TERMUX__=1" \
		--with-extra-ldflags="${jdk_ldflags} -Wl,--as-needed -landroid-shmem -landroid-spawn" \
		--with-fontconfig-include="$TERMUX_PREFIX/include" \
		--with-freetype-include="$TERMUX_PREFIX/include/freetype2" \
		--with-freetype-lib="$TERMUX_PREFIX/lib" \
		--with-giflib=system \
		--with-jvm-variants=server \
		--with-libjpeg=system \
		--with-libpng=system \
		--with-toolchain-type=clang \
		--with-x="$TERMUX_PREFIX/include/X11" \
		--with-zlib=system \
		--x-includes="$TERMUX_PREFIX/include/X11" \
		--x-libraries="$TERMUX_PREFIX/lib" \
		AR="$AR" \
		NM="$NM" \
		OBJCOPY="$OBJCOPY" \
		OBJDUMP="$OBJDUMP" \
		STRIP="$STRIP" \
		CXXFILT="llvm-cxxfilt" \
		BUILD_CC="/usr/bin/clang-17" \
		BUILD_CXX="/usr/bin/clang++-17" \
		BUILD_NM="/usr/bin/llvm-nm-17" \
		BUILD_AR="/usr/bin/llvm-ar-17" \
		BUILD_OBJCOPY="/usr/bin/llvm-objcopy-17" \
		BUILD_STRIP="/usr/bin/llvm-strip-17"
}

termux_step_make() {
	cd build/linux-${TERMUX_ARCH/i686/x86}-server-release
	make JOBS=$TERMUX_PKG_MAKE_PROCESSES images
}

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/lib/jvm/java-21-openjdk
	cp -r build/linux-${TERMUX_ARCH/i686/x86}-server-release/images/jdk/* \
		$TERMUX_PREFIX/lib/jvm/java-21-openjdk/
	find $TERMUX_PREFIX/lib/jvm/java-21-openjdk/ -name "*.debuginfo" -delete

	# Dependent projects may need JAVA_HOME.
	mkdir -p $TERMUX_PREFIX/lib/jvm/java-21-openjdk/etc/profile.d
	echo "export JAVA_HOME=$TERMUX_PREFIX/lib/jvm/java-21-openjdk/" > \
		$TERMUX_PREFIX/lib/jvm/java-21-openjdk/etc/profile.d/java.sh
}

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/lib/jvm/java-21-openjdk/man/man1
	for manpage in *.1; do
		gzip "$manpage"
	done
}

termux_step_create_debscripts() {
	binaries="$(find $TERMUX_PREFIX/lib/jvm/java-21-openjdk/bin -executable -type f | xargs -I{} basename "{}" | xargs echo)"
	manpages="$(find $TERMUX_PREFIX/lib/jvm/java-21-openjdk/man/man1 -name "*.1.gz" | xargs -I{} basename "{}" | xargs echo)"

	for hook in postinst prerm; do
		sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
			-e "s|@binaries@|${binaries}|g" \
			-e "s|@manpages@|${manpages}|g" \
			"$TERMUX_PKG_BUILDER_DIR/hooks/$TERMUX_PACKAGE_FORMAT/$hook.in" > $hook
		chmod 700 $hook
	done

	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ]; then
		echo "post_install" > postupg
	fi
}
