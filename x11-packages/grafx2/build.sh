TERMUX_PKG_HOMEPAGE=https://gitlab.com/GrafX2/grafX2
TERMUX_PKG_DESCRIPTION="The Ultimate 256-color bitmap paint program"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=e6ee44e579defed0ad8a005bed475fd8ea433788
_COMMIT_DATE=20260424
TERMUX_PKG_VERSION="2.9-p${_COMMIT_DATE}"
TERMUX_PKG_SRCURL=git+https://gitlab.com/GrafX2/grafX2.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_SHA256=12b4688adef4a048da0cecc16809b8b2d7e4b771a065a030f053cb4e2b4d88b9
TERMUX_PKG_DEPENDS="freetype, lua51, sdl2 | sdl2-compat, sdl2-image, sdl2-ttf, libiconv"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	make -C "$TERMUX_PKG_SRCDIR/tools/8x8fonts" -j "$TERMUX_PKG_MAKE_PROCESSES"
	cp "$TERMUX_PKG_SRCDIR/bin/generate_png_fonts" .
}

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout "$_COMMIT"

	local pdate="p$(git log -1 --format=%cs | sed 's/-//g')"
	if [[ "$TERMUX_PKG_VERSION" != *"${pdate}" ]]; then
		echo -n "ERROR: The version string \"$TERMUX_PKG_VERSION\" is"
		echo -n " different from what is expected to be; should end"
		echo " with \"${pdate}\"."
		return 1
	fi

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files. Expected: ${s}"
	fi
}

termux_step_pre_configure() {
	# patch like sdl2
	find "$TERMUX_PKG_SRCDIR"/src -type f | \
		xargs -n 1 sed -i \
		-e 's/\([^A-Za-z0-9_]__ANDROID\)\(__[^A-Za-z0-9_]\)/\1_NO_TERMUX\2/g' \
		-e 's/\([^A-Za-z0-9_]__ANDROID\)__$/\1_NO_TERMUX__/g'

	export API="sdl2"
	export SDL2CONFIG="$TERMUX_PREFIX/bin/sdl2-config"

	patch="$TERMUX_PKG_BUILDER_DIR/generate-png-fonts.diff"
	echo "Applying patch: $(basename "$patch")"
	sed 's|@GENERATE_PNG_FONTS@|'"${TERMUX_PKG_HOSTBUILD_DIR}/generate_png_fonts"'|g' \
		"$patch" | patch -p1
}

termux_step_make() {
	make -j "$TERMUX_PKG_MAKE_PROCESSES"
}

termux_step_make_install() {
	make -C src/ install
}

termux_step_post_make_install() {
	mv "$TERMUX_PREFIX"/bin/grafx2{-sdl2,}
}
