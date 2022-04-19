TERMUX_PKG_HOMEPAGE=https://github.com/dottedmag/x2x
TERMUX_PKG_DESCRIPTION="Allows the keyboard, mouse on one X display to be used to control another X display"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20180709
TERMUX_PKG_REVISION=23
_COMMIT=e62a535f9bace33c8b61ea9ff95f040622cb34a2
TERMUX_PKG_SRCURL=https://github.com/dottedmag/x2x/archive/${_COMMIT}.tar.gz
TERMUX_PKG_SHA256=f21d064ed8d6952adbc9cae3261dda9b279a3b330c622a559757f78f5141a54c
TERMUX_PKG_DEPENDS="libxtst"

termux_step_pre_configure() {
	./bootstrap.sh
}
