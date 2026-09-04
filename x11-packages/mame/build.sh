TERMUX_PKG_HOMEPAGE=https://mamedev.org/
TERMUX_PKG_DESCRIPTION="Multi-purpose emulation framework"
TERMUX_PKG_LICENSE="BSD 2-Clause, BSD 3-Clause, BSL-1.0, CC0-1.0, GPL-2.0-only, LGPL-2.1-only, MIT, ZLIB"
TERMUX_PKG_LICENSE_FILE="docs/LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.289"
TERMUX_PKG_SRCURL="https://github.com/mamedev/mame/archive/refs/tags/mame${TERMUX_PKG_VERSION/./}.tar.gz"
TERMUX_PKG_SHA256="0929cc749afabcef892900e10dd90bd8b05f94a7dde8f367ac6a5d2082589f84"
TERMUX_PKG_DEPENDS="libexpat, zlib, zstd, libjpeg-turbo, libflac, lua55, libsqlite, portmidi, portaudio, pulseaudio, utf8proc, libpugixml, fontconfig, sdl2, sdl2-ttf, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="glm, rapidjson, alsa-lib, qt6-qtbase-cross-tools"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
	VERBOSE=1
	NOWERROR=1
	TOOLS=1
	PTR64=$(( TERMUX_ARCH_BITS == 64 ))
	OPTIMIZE=2
	USE_SYSTEM_LIB_ASIO=0
	USE_SYSTEM_LIB_EXPAT=1
	USE_SYSTEM_LIB_ZLIB=1
	USE_SYSTEM_LIB_ZSTD=1
	USE_SYSTEM_LIB_JPEG=1
	USE_SYSTEM_LIB_FLAC=1
	USE_SYSTEM_LIB_LUA=1
	USE_SYSTEM_LIB_SQLITE3=1
	USE_SYSTEM_LIB_PORTMIDI=1
	USE_SYSTEM_LIB_PORTAUDIO=1
	USE_SYSTEM_LIB_UTF8PROC=1
	USE_SYSTEM_LIB_GLM=1
	USE_SYSTEM_LIB_RAPIDJSON=1
	USE_SYSTEM_LIB_PUGIXML=1
"

termux_step_pre_configure() {
	sed -i 's|ext_lib("lua")|ext_lib("lua++5.5")|' scripts/src/main.lua scripts/src/3rdparty.lua
	sed -i '1i #include <sys/prctl.h>' 3rdparty/bx/src/thread.cpp
}

termux_step_make() {
	local target_cflags="$CFLAGS -U__ANDROID__"
	local target_cxxflags="$CXXFLAGS -U__ANDROID__ -I$TERMUX_PREFIX/include/lua5.5"
	local target_ldflags="$LDFLAGS"

	local mame_target
	case "$TERMUX_ARCH" in
		aarch64) mame_target=linux_arm64_clang ;;
		# arm) mame_target=linux_arm_clang ;;
		x86_64) mame_target=linux_x64_clang ;;
		# i686) mame_target=linux_x86_clang ;;
	esac

	env -u CFLAGS -u CXXFLAGS -u LDFLAGS \
	make -j${TERMUX_PKG_MAKE_PROCESSES} ${TERMUX_PKG_EXTRA_MAKE_ARGS} \
		OVERRIDE_CC="$CC" \
		OVERRIDE_CXX="$CXX" \
		OVERRIDE_LD="$CXX" \
		OVERRIDE_AR="$AR" \
		ARCHOPTS_C="$target_cflags" \
		ARCHOPTS_CXX="$target_cxxflags" \
		LDOPTS="$target_ldflags" \
		QT_HOME="$TERMUX_PREFIX/opt/qt6/cross/lib/qt6" \
		"$mame_target"
}

termux_step_make_install() {
	local -a executables=(
		mame
		castool
		chdman
		floptool
		imgtool
		jedutil
		ldresample
		ldverify
		nltool
		nlwav
		pngcmp
		regrep
		romcmp
		srcclean
		testkeys
		unidasm
	)

	# Install mame and all other executables directly to bin/
	for exe in "${executables[@]}"; do
		install -Dm755 "$exe" "$TERMUX_PREFIX/bin/"
	done

	# Prefix mame's split executable to avoid file conflict with coreutils split.
	install -Dm755 "split" "$TERMUX_PREFIX/bin/mame-split"

	install -Dm644 "$TERMUX_PKG_BUILDER_DIR/mame.desktop" -t "$TERMUX_PREFIX/share/applications/"
	install -Dm644 "$TERMUX_PKG_BUILDER_DIR/mame.svg" -t "$TERMUX_PREFIX/share/icons/hicolor/scalable/apps/"

	install -Dm644 src/osd/modules/opengl/shader/glsl*.*h -t "$TERMUX_PREFIX/share/mame/shader/"
	cp -ar artwork bgfx plugins language ctrlr keymaps hash "$TERMUX_PREFIX/share/mame/"

	mkdir -p "$TERMUX_PREFIX/share/doc/mame/"
	cp -a docs/* "$TERMUX_PREFIX/share/doc/mame/"
	rm -rf "$TERMUX_PREFIX/share/doc/mame/man/"

	install -Dm644 docs/man/*.1* -t "$TERMUX_PREFIX/share/man/man1/"
	install -Dm644 docs/man/*.6* -t "$TERMUX_PREFIX/share/man/man6/"
}
