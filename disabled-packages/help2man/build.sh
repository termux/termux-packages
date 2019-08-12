# Build fails in docker image, install-info needed there:
#   build-aux/missing: 81: build-aux/missing: install-info: not found
#   WARNING: 'install-info' is missing on your system.
TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/help2man/
TERMUX_PKG_DESCRIPTION="tool for automatically generating simple manual pages from program output."
TERMUX_PKG_VERSION=1.47.5
TERMUX_PKG_SHA256=7ca60b2519fdbe97f463fe2df66a6188d18b514bfd44127d985f0234ee2461b1
TERMUX_PKG_SRCURL=http://mirrors.kernel.org/gnu/help2man/help2man-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_BUILD_IN_SRC=true
