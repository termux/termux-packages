TERMUX_PKG_HOMEPAGE=https://www.libreoffice.org/
TERMUX_PKG_DESCRIPTION="Free and open source cross-platform office suite"
TERMUX_PKG_LICENSE="MPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=26.8.0.1
TERMUX_PKG_SRCURL=https://download.documentfoundation.org/libreoffice/src/${TERMUX_PKG_VERSION%.*}/libreoffice-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=47506016f8bfc028e0dabba2c38f364bafc7fc6fb2e28829d3c8990aa0382721
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="abseil-cpp, argon2, bison, boost, box2d, clucene, cups, curl, dbus, desktop-file-utils, doxygen, fontconfig, freetype, glib, glm, gpgme, gst-plugins-base, gstreamer, harfbuzz-icu, hicolor-icon-theme, hunspell, libabw, libatomic-ops, libcairo, libcdr, libcmis, libcurl, libe-book, libeot, libepoxy, libepubgen, libetonyek, libexpat, libexttextcat, libfreehand, libglvnd, libgraphite, libhyphen, libicu, libjpeg-turbo, liblangtag, libmspub, libmwaw, libneon, libnspr, libnss, libnumbertext, libodfgen, liborcus, libpagemaker, libpng, libqxp, libraptor2, librevenge, libstaroffice, libtiff, libtommath, libvisio, libwebp, libwpd, libwpg, libwps, libx11, libxext, libxinerama, libxml2, libxrandr, libxslt, libzmf, libzxing-cpp, littlecms, lpsolve, mdds, openjpeg, openldap, openssl, pango, poppler, python, redland, shared-mime-info, which, xdg-utils, xmlsec, zlib"
TERMUX_PKG_BUILD_DEPENDS="ant, boost-headers, cppunit, gtk3, kf6-kconfig, kf6-kcoreaddons, kf6-ki18n, kf6-kio, kf6-kwindowsystem, qt6-qtbase, qt6-qtbase-cross-tools, qt6-qtmultimedia, postgresql, openjdk-21, openjdk-21-x, unixodbc, mariadb, libc++"
TERMUX_PKG_RECOMMENDS="gtk3, kf6-kconfig, kf6-kcoreaddons, kf6-ki18n, kf6-kio, kf6-kwindowsystem, openjdk-21, openjdk-21-x, qt6-qtbase, qt6-qtmultimedia"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_MAKE_INSTALL_TARGET="distro-pack-install"
# TODO: remove --disable-skia, some vulkan related compilation error I couldn't solve.
# TODO: see if we want to add junit pacakge for java unit test and remove --without-junit
# TODO: remove --disable-python and install python site-packages files if we get any issue related to it in future
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--host=$TERMUX_ARCH-linux
--with-extra-buildid=$TERMUX_PKG_VERSION
--with-vendor=Termux
--enable-split-app-modules
--enable-release-build

--disable-skia
--disable-avahi
--enable-dbus
--enable-evolution2
--enable-gio
--enable-gtk3
--disable-gtk4
--disable-introspection
--enable-lto
--enable-openssl
--disable-odk
--enable-scripting-beanshell
--enable-scripting-javascript
--disable-dconf
--disable-report-builder
--enable-ext-wiki-publisher
--enable-ext-nlpsolver
--without-fonts
--with-system-libxml
--with-system-libcdr
--with-system-mdds
--without-myspell-dicts
--with-system-libvisio
--with-system-libcmis
--with-system-libmspub
--with-system-libexttextcat
--with-system-orcus
--with-system-liblangtag
--with-system-libodfgen
--with-system-libmwaw
--with-system-libetonyek
--with-system-libfreehand
--without-system-firebird
--with-system-zxing
--with-system-libtommath
--with-system-libatomic-ops
--with-system-libebook
--with-system-libabw
--with-system-dicts
--with-external-dict-dir=$TERMUX_PREFIX/share/hunspell
--with-external-hyph-dir=$TERMUX_PREFIX/share/hyphen
--with-jdk-home=$TERMUX_PREFIX/lib/jvm/java-21-openjdk
--without-system-beanshell
--with-system-cppunit
--with-system-graphite
--with-system-glm
--with-system-libnumbertext
--with-system-libwpg
--with-system-libwps
--with-system-redland
--with-system-libzmf
--with-system-gpgmepp
--with-system-libstaroffice
--with-ant-home=$TERMUX_PREFIX/opt/ant
--with-system-boost
--with-system-icu
--with-system-cairo
--with-system-libs
--with-system-headers
--without-system-hsqldb
--without-junit
--with-system-clucene
--with-system-box2d
--without-system-dragonbox
--without-system-libfixmath
--without-system-frozen
--without-system-zxcvbn
--without-system-java-websocket
--without-system-rhino
--with-system-libeot
--without-system-afdko
--disable-dependency-tracking

--with-boost-date-time=boost_date_time
--with-boost-filesystem=boost_filesystem
--with-boost-iostreams=boost_iostreams
--with-boost-locale=boost_locale

--without-system-md4c
--without-system-fast-float
--without-system-sane
--disable-python
--without-system-mythes
--without-system-coinmp
--disable-sdremote-bluetooth
--disable-opencl
--with-system-abseil
--disable-gtk3-kde5
--disable-kf5
--enable-kf6
--disable-qt5
--enable-qt6

--with-build-platform-configure-options=--disable-python
"

termux_step_pre_configure() {
	export KF6INC=$TERMUX_PREFIX/include
	export KF6LIB=$TERMUX_PREFIX/lib

	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		export qt6_libexec_dirs="$TERMUX_PREFIX/lib/qt6"
		termux-fix-shebang ./solenv/bin/*
	else
		export qt6_libexec_dirs="$TERMUX_PREFIX/opt/qt6/cross/lib/qt6"
		# AC_PATH_PROGS(QMAKE6, ...) honors a preset QMAKE6; host-qmake6
		# (from qt6-qtbase) runs on the build host but -query reports
		# target paths, same as mkvtoolnix/leocad/signond do for qmake6.
		export QMAKE6="$TERMUX_PREFIX/lib/qt6/bin/host-qmake6"
	fi

	# lld is strict about version script assignments. sal.map references
	# symbols that don't exist on Android (backtrace from missing execinfo.h,
	# libstdc++ ABI symbols absent with libc++). Downgrade to warnings.
	export LDFLAGS+=" -Wl,--undefined-version"

	# Bionic resolves weak vague-linkage symbols (C++ exception type_info,
	# dynamic_cast RTTI) per dlopen group, so typed catches/casts across
	# dlopen'd UNO components miss (white Start Center, sidebar crash,
	# "General input/output error" on save). Only members of the linker's
	# global group interpose ahead of later dlopen groups, and Bionic
	# ignores dlopen(RTLD_GLOBAL) for that purpose (proven on-device with
	# a minimal two-library experiment; LD_PRELOAD was the interim fix).
	# DF_1_GLOBAL baked into every .so via -z global puts each lib in the
	# global group at load time: first-loaded copy of every type_info wins
	# process-wide, unifying RTTI in all directions. The only remaining
	# source patch for this bug class is 0023 (UNO bridge type_info lookup
	# must use RTLD_DEFAULT, since a dlopen(nullptr) handle on Bionic never
	# sees libraries dlopen'd after startup). Verify after build:
	#   readelf -d libsclo.so | grep FLAGS_1   -> must show GLOBAL
	export LDFLAGS+=" -Wl,-z,global"

	# 32-bit arches: CoinMP libraries need compiler-rt builtins from libgcc
	# (ARM: __aeabi_* division helpers; x86: __divdi3/__moddi3 for 64-bit division).
	# Without explicit linkage the Termux symbol checker flags them as undefined.
	if [ "$TERMUX_ARCH" = "arm" ] || [ "$TERMUX_ARCH" = "i686" ]; then
		local _libgcc_file="$($CC -print-libgcc-file-name)"
		export TERMUX_32BIT_BUILTINS="$_libgcc_file"
		# -Wl, prefix: a bare .a path in LDFLAGS makes libtool (used by
		# autotools externals like coinmp) ar-insert the archive itself
		# into static convenience archives -> 'not an ELF file' at link.
		export LDFLAGS+=" -Wl,$_libgcc_file"
		export CMAKE_SHARED_LINKER_FLAGS="${CMAKE_SHARED_LINKER_FLAGS:-} $_libgcc_file"
		export CMAKE_EXE_LINKER_FLAGS="${CMAKE_EXE_LINKER_FLAGS:-} $_libgcc_file"
	fi
	# Ensure meson and ninja are available for CONF-FOR-BUILD (host)
	# which needs them to build internal harfbuzz
	termux_setup_meson
	termux_setup_ninja

	# Remove setup.cfg so Termux doesn't treat this as a Python package
	# and try 'pip install .' during the install step
	rm -f setup.cfg

	# Regenerate configure from patched configure.ac
	NOCONFIGURE=1 ./autogen.sh

	# Use pkg-config-wrapper
	mkdir -p $TERMUX_PKG_TMPDIR/pkg-config-wrapper-bin
	cat >$TERMUX_PKG_TMPDIR/pkg-config-wrapper-bin/pkg-config <<-HERE
		#!/bin/sh

		if [ "\$CROSS_COMPILING" = TRUE ]; then
			export PKG_CONFIG_PATH=
			export PKG_CONFIG_DIR=
			export PKG_CONFIG_LIBDIR=$PKG_CONFIG_LIBDIR
		else
			unset PKG_CONFIG_PATH
			unset PKG_CONFIG_DIR
			unset PKG_CONFIG_LIBDIR
		fi

		exec /usr/bin/pkg-config "\$@"
	HERE
	chmod +x $TERMUX_PKG_TMPDIR/pkg-config-wrapper-bin/pkg-config
	export PATH="$TERMUX_PKG_TMPDIR/pkg-config-wrapper-bin:$PATH"

	# Do NOT set *_FOR_BUILD variables. The configure.ac patch
	# (0001) unsets CFLAGS/CXXFLAGS/LDFLAGS/CPPFLAGS/CPP for the
	# CONF-FOR-BUILD subshell. If *_FOR_BUILD are not set, the host
	# build will use system defaults (which is correct - it should
	# use the host compiler's default paths, not Termux paths).
}

termux_step_configure() {
	if [ "$TERMUX_CONTINUE_BUILD" == "true" ]; then
		termux_step_pre_configure
		cd $TERMUX_PKG_SRCDIR
		return
	fi

	termux_step_configure_autotools
}

termux_step_make() {
	make -j $(nproc)
}
