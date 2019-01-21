TERMUX_PKG_HOMEPAGE=http://www.fltk.org/
TERMUX_PKG_DESCRIPTION="Simple text editor"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"
TERMUX_PKG_DEPENDS="fltk, libc++"
TERMUX_PKG_VERSION=1.0-termux
TERMUX_PKG_REVISION=6

termux_step_make() {
	"${CXX}" \
		${CPPFLAGS} \
		${CXXFLAGS} \
		"${TERMUX_PKG_BUILDER_DIR}/fltk-editor.cxx" \
		-o fltk-editor \
		${LDFLAGS} -lfltk
}

termux_step_make_install() {
	install -Dm700 fltk-editor "${TERMUX_PREFIX}/bin/fltk-editor"
}
