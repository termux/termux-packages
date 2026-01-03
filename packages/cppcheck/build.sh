TERMUX_PKG_HOMEPAGE=https://github.com/danmar/cppcheck
TERMUX_PKG_DESCRIPTION="tool for static C/C++ code analysis"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.19.1"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology # Upstream only releases major versions theough GitHub. Other minor updates are released using git tags, better rely on repology for updated versiom
TERMUX_PKG_SRCURL=https://github.com/danmar/cppcheck/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=49bdf1d7826d60053575b78d3192d81d54970dbfb356590f7476de250b1a4234
TERMUX_PKG_DEPENDS="libandroid-execinfo, libc++"

# Prevent running dmake during builds. dmake just generates Makefile which we
# aren't using, and QT translation files, but as we are not building the GUI,
# there is no need.  And anyways will lead to "Exec format" error as running
# target binaries on host
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DUSE_MATCHCOMPILER=On -DDISABLE_DMAKE=ON"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-execinfo"
}
