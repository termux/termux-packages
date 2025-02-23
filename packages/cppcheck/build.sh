TERMUX_PKG_HOMEPAGE=https://github.com/danmar/cppcheck
TERMUX_PKG_DESCRIPTION="tool for static C/C++ code analysis"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.17.0"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology # Upstream only releases major versions theough GitHub. Other minor updates are released using git tags, better rely on repology for updated versiom
TERMUX_PKG_SRCURL=https://github.com/danmar/cppcheck/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=54c31a5ba6913a760ca6c5a1138e6a8c97e74e6b532e0d0aeb4ae9dd3dda2649
TERMUX_PKG_DEPENDS="libc++"

# Prevent running dmake during builds. dmake just generates Makefile which we
# aren't using, and QT translation files, but as we are not building the GUI,
# there is no need.  And anyways will lead to "Exec format" error as running
# target binaries on host
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DUSE_MATCHCOMPILER=On -DDISABLE_DMAKE=ON"
