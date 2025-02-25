TERMUX_PKG_HOMEPAGE=https://github.com/danmar/cppcheck
TERMUX_PKG_DESCRIPTION="tool for static C/C++ code analysis"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.17.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology # Upstream only releases major versions theough GitHub. Other minor updates are released using git tags, better rely on repology for updated versiom
TERMUX_PKG_SRCURL=https://github.com/danmar/cppcheck/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=5a639adf8d5f2520a280eb0f0fc25605cd8a3d4336a27f4a3e3e0f0c0c9789da
TERMUX_PKG_DEPENDS="libc++"

# Prevent running dmake during builds. dmake just generates Makefile which we
# aren't using, and QT translation files, but as we are not building the GUI,
# there is no need.  And anyways will lead to "Exec format" error as running
# target binaries on host
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DUSE_MATCHCOMPILER=On -DDISABLE_DMAKE=ON"
