TERMUX_PKG_HOMEPAGE=https://warpdl.org
TERMUX_PKG_DESCRIPTION="Warpdl is a powerful and versatile cross-platform download manager."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.4"
TERMUX_PKG_SRCURL=https://github.com/warpdl/warpdl/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d389d74f25328dd2a812ac2f17e14082eaeef71280b9ed8f8163caf54cd26f8a
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	go mod tidy
	go build -o warpdl -ldflags="-checklinkname=0 -s -w"
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin "$TERMUX_PKG_SRCDIR"/warpdl
}
