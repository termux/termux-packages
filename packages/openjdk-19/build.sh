TERMUX_PKG_HOMEPAGE=https://github.com/openjdk/mobile
TERMUX_PKG_DESCRIPTION="Java development kit and runtime"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=19.0
_COMMIT=f887a46540c61a028ace8327d9bcb8e1b370a9c7
TERMUX_PKG_SRCURL=https://github.com/openjdk/mobile/archive/$_COMMIT.tar.gz
TERMUX_PKG_SHA256=04c91dfcb5cea6cac515a3fbbc285815ae5b3fa237ac47d268ab2cb7a4a7d173
TERMUX_PKG_DEPENDS="libiconv, libjpeg-turbo, zlib"
TERMUX_PKG_BUILD_DEPENDS="cups, libandroid-spawn, xorgproto"
# openjdk-19-x is recommended because X11 separation is still very experimental.
TERMUX_PKG_RECOMMENDS="ca-certificates-java, openjdk-19-x, resolv-conf"
TERMUX_PKG_SUGGESTS="cups"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HAS_DEBUG=false

termux_step_pre_configure() {
	unset JAVA_HOME
}

termux_step_configure() {
	local jdk_ldflags="-L${TERMUX_PREFIX}/lib -Wl,-rpath=$TERMUX_PREFIX/lib/jvm/java-19-openjdk/lib -Wl,-rpath=${TERMUX_PREFIX}/lib -Wl,--enable-new-dtags"
	bash ./configure \
		--disable-precompiled-headers \
		--disable-warnings-as-errors \
		--enable-option-checking=fatal \
		--openjdk-target=$TERMUX_HOST_PLATFORM \
		--with-cups-include="$TERMUX_PREFIX/include" \
		--with-debug-level=release \
		--with-extra-cflags="$CFLAGS $CPPFLAGS -DLE_STANDALONE -D__TERMUX__=1" \
		--with-extra-cxxflags="$CXXFLAGS $CPPFLAGS -DLE_STANDALONE -D__TERMUX__=1" \
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
		BUILD_CC="/usr/bin/clang-13" \
		BUILD_CXX="/usr/bin/clang++-13" \
		BUILD_NM="/usr/bin/llvm-nm-13" \
		BUILD_AR="/usr/bin/llvm-ar-13" \
		BUILD_OBJCOPY="/usr/bin/llvm-objcopy-13" \
		BUILD_STRIP="/usr/bin/llvm-strip-13"
}

termux_step_make() {
	cd build/linux-${TERMUX_ARCH/i686/x86}-server-release
	make JOBS=1 images
}

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/lib/jvm/java-19-openjdk
	cp -r build/linux-${TERMUX_ARCH/i686/x86}-server-release/images/jdk/* \
		$TERMUX_PREFIX/lib/jvm/java-19-openjdk/
	find $TERMUX_PREFIX/lib/jvm/java-19-openjdk/ -name "*.debuginfo" -delete

	# Dependent projects may need JAVA_HOME.
	mkdir -p $TERMUX_PREFIX/lib/jvm/java-19-openjdk/etc/profile.d
	echo "export JAVA_HOME=$TERMUX_PREFIX/lib/jvm/java-19-openjdk/" > \
		$TERMUX_PREFIX/lib/jvm/java-19-openjdk/etc/profile.d/java.sh
}

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/lib/jvm/java-19-openjdk/man/man1
	for manpage in *.1; do
		gzip "$manpage"
	done
}

termux_step_create_debscripts() {
	local binaries="$(find $TERMUX_PREFIX/lib/jvm/java-19-openjdk/bin -executable -type f | xargs -I{} basename "{}")"
	local manpages="$(find $TERMUX_PREFIX/lib/jvm/java-19-openjdk/man/man1 -name "*.1.gz" | xargs -I{} basename "{}")"
	cat <<-EOF >./postinst
		#!$TERMUX_PREFIX/bin/sh
		if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" = "configure" ] || [ "\$1" = "abort-upgrade" ]; then
			if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
				update-alternatives --install $TERMUX_PREFIX/etc/profile.d/java.sh java-profile	$TERMUX_PREFIX/lib/jvm/java-19-openjdk/etc/profile.d/java.sh 60
				for tool in $binaries; do
					update-alternatives --install \
						$TERMUX_PREFIX/bin/\$tool \$tool \
						$TERMUX_PREFIX/lib/jvm/java-19-openjdk/bin/\$tool 60
				done

				for manpage in $manpages; do
					update-alternatives --install \
						$TERMUX_PREFIX/share/man/man1/\$manpage.gz \$manpage \
						$TERMUX_PREFIX/lib/jvm/java-19-openjdk/man/man1/\$manpage.gz 60
				done
			fi
		fi
	EOF

	cat <<-EOF >./prerm
		#!$TERMUX_PREFIX/bin/sh
		if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" != "upgrade" ]; then
			if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
				for tool in $binaries; do
					update-alternatives --remove \$tool $TERMUX_PREFIX/bin/\$tool
				done

				for manpage in $manpages; do
					update-alternatives --remove \$manpage $TERMUX_PREFIX/share/man/man1/\$manpage.gz
				done
			fi
		fi
	EOF
}
