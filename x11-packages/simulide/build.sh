TERMUX_PKG_HOMEPAGE=https://simulide.com/p/
TERMUX_PKG_DESCRIPTION="Simple real time electronic circuit simulator"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=13cb963d9aae083b22e3446fafdfbcb1a3af7310
TERMUX_PKG_VERSION=2025.10.29
TERMUX_PKG_SRCURL=git+https://github.com/eeTools/SimulIDE-dev
TERMUX_PKG_SHA256=73d85be6baad944a709c470088a47e5da1dd939bcc67343134027921891e843c
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="libc++, libelf, qt5-qtbase, qt5-qtmultimedia, qt5-qtscript, qt5-qtserialport, qt5-qtsvg, simulide-data"
TERMUX_PKG_BUILD_DEPENDS="dos2unix, qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local version="$(git log -1 --format=%cs | sed 's/-/./g')"
	if [ "$version" != "$TERMUX_PKG_VERSION" ]; then
		echo -n "ERROR: The specified version \"$TERMUX_PKG_VERSION\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
	fi

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		DOS2UNIX="$TERMUX_PKG_TMPDIR/dos2unix"
		(. "$TERMUX_SCRIPTDIR/packages/dos2unix/build.sh"; TERMUX_PKG_SRCDIR="$DOS2UNIX" termux_step_get_source)
		pushd "$DOS2UNIX"
		make dos2unix
		popd # DOS2UNIX
		export PATH="$DOS2UNIX:$PATH"
	fi

	find "$TERMUX_PKG_SRCDIR" -type f -print0 | xargs -0 dos2unix
}

termux_step_pre_configure() {
	TERMUX_PKG_BUILDDIR+="/build_XX"
	export PATH="$TERMUX_PREFIX/opt/qt/cross/bin:$PATH"
}

termux_step_configure() {
	qmake -spec "$TERMUX_PREFIX/lib/qt/mkspecs/termux-cross"
}

termux_step_make_install() {
	install -Dm755 -t "$TERMUX_PREFIX/bin" \
		"$TERMUX_PKG_BUILDDIR"/executables/*/simulide
	install -Dm644 -t "$TERMUX_PREFIX/share/applications" \
		"$TERMUX_PKG_SRCDIR/resources/simulide.desktop"
	install -Dm644 -t "$TERMUX_PREFIX/share/pixmaps" \
		"$TERMUX_PKG_SRCDIR/resources/icons/simulide.png"
	install -Dm644 "$TERMUX_PKG_SRCDIR/resources/simulide-mime.xml" \
		"$TERMUX_PREFIX/share/mime/packages/simulide.xml"
	rm -rf "$TERMUX_PREFIX/share/simulide" \
		"$TERMUX_PKG_SRCDIR"/resources/{icons,readme,simulide-mime.xml,simulide.desktop}
	mkdir -p "$TERMUX_PREFIX/share"
	mv "$TERMUX_PKG_SRCDIR"/resources "$TERMUX_PREFIX/share/simulide"
}
