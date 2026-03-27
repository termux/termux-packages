TERMUX_PKG_HOMEPAGE=https://github.com/danmar/cppcheck
TERMUX_PKG_DESCRIPTION="tool for static C/C++ code analysis"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.20.1"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology # Upstream only releases major versions theough GitHub. Other minor updates are released using git tags, better rely on repology for updated versiom
TERMUX_PKG_SRCURL=https://github.com/danmar/cppcheck/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=97634b598b8adf23e6cbd75aec5a8ac2d8b5f49f53e6a145b1c8380525c48a91
TERMUX_PKG_DEPENDS="libandroid-execinfo, libc++"

# Prevent running dmake during builds. dmake just generates Makefile which we
# aren't using, and QT translation files, but as we are not building the GUI,
# there is no need.  And anyways will lead to "Exec format" error as running
# target binaries on host
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DUSE_MATCHCOMPILER=On -DDISABLE_DMAKE=ON"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-execinfo"
}
