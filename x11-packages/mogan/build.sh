TERMUX_PKG_HOMEPAGE=https://github.com/XmacsLabs/mogan
TERMUX_PKG_DESCRIPTION="A structure editor forked from GNU TeXmacs"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2026.3.7"
TERMUX_PKG_SRCURL="https://github.com/XmacsLabs/mogan/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=676966aefccaa8f8e4add2916fe02362c69b2bb3d991635a81a46f2dee3c6383
TERMUX_PKG_DEPENDS="dbus, fontconfig, freetype, ghostscript, libandroid-complex-math, libandroid-execinfo, libandroid-spawn, libandroid-wordexp, libc++, libcurl, libexpat, libffi, libiconv, libjpeg-turbo, libpng, libx11, libxkbcommon, libxml2, mupdf, openssl, otf-noto-sans-cjk, qt6-qtbase, qt6-qtdeclarative, qt6-qtnetworkauth, qt6-qtsvg, zlib"
TERMUX_PKG_BUILD_DEPENDS="qt6-qtbase-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_RM_AFTER_INSTALL="
lib/libcurl.so
"

termux_pkg_auto_update() {
	local api_url="https://api.github.com/repos/XmacsLabs/mogan/git/refs/tags"
	local latest_refs_tags=$(curl -s "${api_url}" | jq .[].ref | sed -ne "s|.*v\(.*\)\"|\1|p")
	if [[ -z "${latest_refs_tags}" ]]; then
		echo "WARN: Unable to get latest refs tags from upstream. Try again later." >&2
		return
	fi
	local latest_version=$(echo "${latest_refs_tags}" | grep -E "^[0-9]{4}\\.[0-9]+\\.[0-9]+$" | sort -V | tail -n1)

	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_pre_configure() {
	export PKG_CONFIG_LIBDIR="$TERMUX_PREFIX/lib/pkgconfig:$TERMUX_PREFIX/share/pkgconfig"

	# this is a workaround for build-all.sh issue
	TERMUX_PKG_DEPENDS+=", mogan-data"

	termux_setup_cmake
	termux_setup_ninja
	termux_setup_xmake

	# xmake tests -ldl wrongly?
	LD="${CXX}"

	# allows 'scripts/run-docker.sh ./build-package,sh -I -f -a all mogan' to work
	# without causing 'ld.lld: error: /home/builder/.xmake/packages/s/s7/
	# 20241122/2613d5544f43431dad530be0c61b8a28/lib/libs7.a(s7.c.o)
	# is incompatible with armelf_linux_eabi'
	export XMAKE_GLOBALDIR="$TERMUX_PKG_TMPDIR"

	# for some reason building mogan can corrupt $TERMUX_PREFIX/lib/libcurl.so
	# and /home/builder/.termux-build/_cache/xmake-2.9.5/bin/xmake ,
	# but if they are backed up, then restored when the build completes, the chance
	# of ruining the builds of other packages after mogan (including repeated builds of mogan)
	# is reduced.
	mkdir -p "$TERMUX_PKG_TMPDIR/backup_dir"
	export XMAKE_ORIG=$(command -v xmake)
	cp "$TERMUX_PREFIX/lib/libcurl.so" "$TERMUX_PKG_TMPDIR/backup_dir/libcurl.so"
	cp "$XMAKE_ORIG" "$TERMUX_PKG_TMPDIR/backup_dir/xmake"

	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" ]]; then
		# xmake finds Qt by running qmake from an SDK directory; Termux has only a cross Qt
		# with a different layout, so present a scratch SDK made of a qmake wrapper and an include symlink.
		install -Dm755 "${TERMUX_PKG_BUILDER_DIR}/qmake.sh" "${TERMUX_PKG_TMPDIR}/qtsdk/bin/qmake"
		sed \
			-e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
			-e "s|@QT_SDK_DIR@|${TERMUX_PKG_TMPDIR}/qtsdk|g" \
			-i "${TERMUX_PKG_TMPDIR}/qtsdk/bin/qmake"
		ln -sf qmake "${TERMUX_PKG_TMPDIR}/qtsdk/bin/qmake6"
		ln -sfn "${TERMUX_PREFIX}/include/qt6" "${TERMUX_PKG_TMPDIR}/qtsdk/include"
		export PATH="${TERMUX_PKG_TMPDIR}/qtsdk/bin:${TERMUX_PREFIX}/opt/qt6/cross/bin:${PATH}"
	fi

	command -v qmake
	qmake -query
}

termux_step_make() {
	local host_platform="${TERMUX_ARCH}-linux-android"
	case "${TERMUX_ARCH}" in
	arm) host_platform="armv7a-linux-androideabi" ;;
	esac

	# xmake's qtbase package requires aqt and dpkg; Qt comes from the system, so stub them.
	# Cross objcopy and strip are used for the debug symbols of the target binaries.
	mkdir -p "$TERMUX_PKG_TMPDIR/nodpkg"
	printf '#!/bin/sh\n[ "$1" = --version ]\n' > "$TERMUX_PKG_TMPDIR/nodpkg/dpkg"
	printf '#!/bin/sh\necho "aqt, version 3.3.0"\n' > "$TERMUX_PKG_TMPDIR/nodpkg/aqt"
	chmod +x "$TERMUX_PKG_TMPDIR/nodpkg/dpkg" "$TERMUX_PKG_TMPDIR/nodpkg/aqt"
	ln -sf "${TERMUX_STANDALONE_TOOLCHAIN}/bin/llvm-objcopy" "$TERMUX_PKG_TMPDIR/nodpkg/objcopy"
	ln -sf "${TERMUX_STANDALONE_TOOLCHAIN}/bin/llvm-strip" "$TERMUX_PKG_TMPDIR/nodpkg/strip"
	local PATH="$TERMUX_PKG_TMPDIR/nodpkg:$PATH"
	export CPATH="$TERMUX_PREFIX/include/freetype2"

	echo "xrepo update-repo"
	xrepo update-repo

	echo "xmake config"
	xmake config \
		--yes \
		--verbose \
		--diagnosis \
		-m releasedbg \
		--sdk="${TERMUX_STANDALONE_TOOLCHAIN}" \
		--qt="${TERMUX_PKG_TMPDIR}/qtsdk" \
		--cross="${host_platform}-" \
		--cflags="${CPPFLAGS} ${CFLAGS} -include ${TERMUX_PKG_BUILDER_DIR}/complex-compat.h" \
		--cxxflags="${CPPFLAGS} ${CXXFLAGS}" \
		--ldflags="${LDFLAGS} -landroid-complex-math -landroid-execinfo -landroid-spawn -landroid-wordexp -liconv"

	echo "xmake build"
	xmake build \
		--yes \
		--verbose \
		--diagnosis \
		--jobs="${TERMUX_PKG_MAKE_PROCESSES}" \
		stem
}

termux_step_make_install() {
	echo "xmake install"
	xmake install \
		--yes \
		--verbose \
		--diagnosis \
		-o "${TERMUX_PKG_TMPDIR}/stage" \
		stem
	cp -r "${TERMUX_PKG_TMPDIR}/stage"/{bin,share} "${TERMUX_PREFIX}/"
}

termux_step_post_make_install() {
	cp "$TERMUX_PKG_TMPDIR/backup_dir/libcurl.so" "$TERMUX_PREFIX/lib/libcurl.so"
	cp "$TERMUX_PKG_TMPDIR/backup_dir/xmake" "$XMAKE_ORIG"
}
