TERMUX_PKG_HOMEPAGE=https://openscad.org/
TERMUX_PKG_DESCRIPTION="The programmers solid 3D CAD modeller (X11 build)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2021.01"
TERMUX_PKG_SRCURL="https://files.openscad.org/openscad-$TERMUX_PKG_VERSION.src.tar.gz"
TERMUX_PKG_SHA256=d938c297e7e5f65dbab1461cac472fc60dfeaa4999ea2c19b31a4184f2d70359
TERMUX_PKG_DEPENDS="boost, double-conversion, fontconfig, freetype, glib, glu, glew, harfbuzz, libc++, libcairo, libgmp, libmpfr, libnettle, libx11, libxml2, libzip, opencsg, opengl, qscintilla, qt5-qtbase, qt5-qtmultimedia"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, cgal, eigen"
# error: .popsection without corresponding .pushsection
TERMUX_PKG_EXCLUDED_ARCHES="arm"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_CONFLICTS="openscad"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
-DBoost_USE_STATIC_LIBS=OFF
-DBUILD_SHARED_LIBS=ON
-DBUILD_STATIC_LIBS=OFF
-DNULLGL=OFF
"

termux_step_make_install () {
	rm -rf "$TERMUX_PREFIX/share/openscad"
	mkdir -p "$TERMUX_PREFIX/share/openscad"
	install openscad "$TERMUX_PREFIX/bin/"
	cp -r "$TERMUX_PKG_SRCDIR/libraries" "$TERMUX_PREFIX/share/openscad/"
	cp -r "$TERMUX_PKG_SRCDIR/examples" "$TERMUX_PREFIX/share/openscad/"
	cp -r "$TERMUX_PKG_SRCDIR/color-schemes" "$TERMUX_PREFIX/share/openscad/"
	cp -r "$TERMUX_PKG_SRCDIR/templates" "$TERMUX_PREFIX/share/openscad/"
	install -Dm644 "$TERMUX_PKG_SRCDIR/icons/openscad.desktop" \
		"$TERMUX_PREFIX/share/applications/openscad.desktop"
	for i in 48 64 128 256 512; do
		install -Dm644 "$TERMUX_PKG_SRCDIR/icons/openscad-${i}.png" \
			"$TERMUX_PREFIX/share/icons/hicolor/${i}x${i}/apps/openscad.png"
	done
	install -Dm644 "$TERMUX_PKG_SRCDIR/icons/openscad.xml" \
		"$TERMUX_PREFIX/share/mime/packages/openscad.xml"
}
