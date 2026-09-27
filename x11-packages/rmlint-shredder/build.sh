TERMUX_PKG_HOMEPAGE=https://github.com/sahib/rmlint
TERMUX_PKG_DESCRIPTION="GTK+ GUI for rmlint"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.10.3"
TERMUX_PKG_SRCURL=https://github.com/sahib/rmlint/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8ffdbd5d09d15c8717ae55497e90d6fa46f085b45ac1056f2727076da180c33e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gtk3, gtksourceview4, librsvg, pygobject, python, python-pip, rmlint"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_SETUP_PYTHON=true

termux_step_make() {
	glib-compile-resources \
		--sourcedir="$TERMUX_PKG_SRCDIR/gui/shredder/resources" \
		--target="$TERMUX_PKG_SRCDIR/gui/shredder/resources/shredder.gresource" \
		"$TERMUX_PKG_SRCDIR/gui/shredder/resources/shredder.gresource.xml"
}

termux_step_make_install() {
	local _pip="pip"
	if command -v cross-pip >/dev/null 2>&1; then
		_pip="cross-pip"
	fi
	$_pip install --no-deps --prefix="$TERMUX_PREFIX" "$TERMUX_PKG_SRCDIR/gui"
}

termux_step_post_make_install() {
	install -Dm644 -t "$TERMUX_PREFIX/share/applications" "$TERMUX_PKG_SRCDIR/gui/shredder.desktop"
	install -Dm644 -t "$TERMUX_PREFIX/share/icons/hicolor/scalable/apps" "$TERMUX_PKG_SRCDIR/gui/shredder/resources/shredder.svg"
	install -Dm644 -t "$TERMUX_PREFIX/share/glib-2.0/schemas" "$TERMUX_PKG_SRCDIR/gui/shredder/resources/org.gnome.Shredder.gschema.xml"
}
