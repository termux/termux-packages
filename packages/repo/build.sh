TERMUX_PKG_VERSION=2.20
TERMUX_PKG_HOMEPAGE=https://android.googlesource.com/tools/repo
TERMUX_PKG_DESCRIPTION="The Multiple Git Repository Tool from the Android Open Source Project"
TERMUX_PKG_LICENSE="APACHE"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_DEPENDS="git, python"
TERMUX_PKG_SRCURL=https://github.com/GerritCodeReview/git-repo/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256="d9f09d1769bc5800cb6cb4832f0baaedba525909ec3c34bc91c98cb0969684e5"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -vDm755 repo "$TERMUX_PREFIX/bin/repo"
	install -vDm644 docs/manifest-format.md "$TERMUX_PREFIX/share/doc/repo/manifest-format.md"
	install -vDm644 -t "$TERMUX_PREFIX/share/man/man1" man/*
}
