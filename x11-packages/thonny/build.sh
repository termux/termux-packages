TERMUX_PKG_HOMEPAGE=https://thonny.org
TERMUX_PKG_DESCRIPTION="Python IDE for beginners (Tkinter based, learning-focused)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="5.0.0"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/thonny/thonny/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=26645a0fd72ed2d41bc901ba72aa89b09c3b1ec70b16dbad82e8597582c7a462
TERMUX_PKG_DEPENDS="python, python-tkinter, python-pip, xdg-utils"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="uv_build, wheel"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make_install() {
	pip install . --no-deps --prefix="$TERMUX_PREFIX" -vv --no-build-isolation

	if ! compgen -G "packaging/icons/thonny-[0-9]*x[0-9]*.png" > /dev/null; then
		termux_error_exit "No icon files found in packaging/icons"
	fi

	local icon size
	for icon in packaging/icons/thonny-[0-9]*x[0-9]*.png; do
		size="${icon##*thonny-}"
		size="${size%.png}"
		install -Dm644 "$icon" \
			"$TERMUX_PREFIX/share/icons/hicolor/${size}/apps/thonny.png"
	done

	mkdir -p "$TERMUX_PREFIX/share/applications"
	cat <<- EOF > "$TERMUX_PREFIX/share/applications/thonny.desktop"
	[Desktop Entry]
	Type=Application
	Name=Thonny
	Comment=Python IDE for beginners
	Exec=thonny
	Icon=thonny
	Categories=Development;IDE;
	EOF
}
