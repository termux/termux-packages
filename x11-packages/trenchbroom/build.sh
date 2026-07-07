TERMUX_PKG_HOMEPAGE=https://trenchbroom.github.io/
TERMUX_PKG_DESCRIPTION="Level editor for Quake-engine based games"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2026.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/TrenchBroom/TrenchBroom/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=abb7d8a241362cea5bccbf2d6c0fc7406943ab126a2b5e8ab235b41c8d77b36c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="assimp, cpptrace, freeimage, libtinyxml2, opengl, qt6-qtbase, qt6-qtsvg"
# stduuid header-only library
# miniz and fmt needed during build, but not showing in ldd command on final binary
TERMUX_PKG_BUILD_DEPENDS="stduuid, miniz, fmt"
# upstream does not develop builds for 32-bit targets
# https://github.com/TrenchBroom/TrenchBroom/issues/3651
# MiniGl.h:50:7: error: typedef redefinition with different types
# ('std::intptr_t' (aka 'int') vs 'long') 50 | using GLintptr = std::intptr_t;
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_RM_AFTER_INSTALL="
var/cache/fontconfig
"

termux_step_pre_configure() {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Dfreeimage_DIR=$TERMUX_PKG_SRCDIR/cmake/packages"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Dfreetype_DIR=$TERMUX_PKG_SRCDIR/cmake/packages"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Dfreetype_INCLUDE_DIR=$TERMUX_PREFIX/include/freetype2"

	local patch="$TERMUX_PKG_BUILDER_DIR/set-version.diff"
	echo "Applying patch: $(basename "$patch")"
	sed -e "s%\@TERMUX_PKG_VERSION\@%${TERMUX_PKG_VERSION}%g" \
		"$patch" | patch --silent -p1
}

termux_step_make_install() {
	install -Dm755 "$TERMUX_PKG_BUILDDIR/app/TrenchBroom/TrenchBroom" \
		-t "$TERMUX_PREFIX/bin"
	ln -sf TrenchBroom "$TERMUX_PREFIX/bin/trenchbroom"
	rm -rf "$TERMUX_PREFIX/share/TrenchBroom"
	mkdir -p "$TERMUX_PREFIX/share/TrenchBroom"
	mv "$TERMUX_PKG_SRCDIR/app/TrenchBroom/resources/graphics"/{icons,images} \
		"$TERMUX_PKG_SRCDIR/app/TrenchBroom/resources/"
	cp -r "$TERMUX_PKG_SRCDIR/app/TrenchBroom/resources"/{defaults,fonts,games,icons,images,qrc,shader,stylesheets} \
		"$TERMUX_PREFIX/share/TrenchBroom/"
	install -Dm644 "${TERMUX_PKG_SRCDIR}/app/TrenchBroom/resources/linux/icons/icon_256.png" \
		"${TERMUX_PREFIX}/share/pixmaps/trenchbroom.png"
	install -Dm644 "${TERMUX_PKG_SRCDIR}/app/TrenchBroom/resources/linux/trenchbroom.desktop" \
		-t "${TERMUX_PREFIX}/share/applications"
	install -Dm644 "${TERMUX_PKG_SRCDIR}/app/TrenchBroom/resources/linux/trenchbroom.xml" \
		-t "${TERMUX_PREFIX}/share/mime/packages"
}


termux_step_create_debscripts() {
	# the app needs this on first launch to avoid error about lock file
	cat <<- POSTINST_EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	mkdir -p $TERMUX_ANDROID_HOME/.TrenchBroom
	POSTINST_EOF

	chmod 0755 postinst

	if [[ "$TERMUX_PACKAGE_FORMAT" == "pacman" ]]; then
		echo "post_install" > postupg
	fi
}
