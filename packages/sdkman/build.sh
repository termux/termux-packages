TERMUX_PKG_HOMEPAGE="https://sdkman.io/"
TERMUX_PKG_DESCRIPTION="The SDKMAN! Command Line Interface"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.24.0"
TERMUX_PKG_SRCURL="https://github.com/sdkman/sdkman-cli/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="8820ded3a380ca54b433fea9e4bc77b59baf06d17eb6a7f21f83d593342343c0"
TERMUX_PKG_DEPENDS="zip, unzip"
TERMUX_PKG_BUILD_DEPENDS="gradle"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	./gradlew build
}
