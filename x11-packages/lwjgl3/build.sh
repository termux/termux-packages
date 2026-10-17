TERMUX_PKG_HOMEPAGE=https://www.lwjgl.org/
TERMUX_PKG_DESCRIPTION="Lightweight Java Game Library version 3"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="LICENSE.md"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.4.1"
TERMUX_PKG_SRCURL="https://github.com/LWJGL/lwjgl3/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=86f22fa70bdb8dbf9ea205daa0e9d88dd80fa7cecbd60025f687b7400edb11fd
TERMUX_PKG_DEPENDS="openjdk-25, openjdk-25-x"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	if [[ ! -v ANT_HOME ]]; then
		if [[ ${TERMUX_ON_DEVICE_BUILD} = false ]]; then
			termux_download_ubuntu_packages ant
		fi
	fi
}

termux_step_pre_configure() {
	if [[ ${TERMUX_ON_DEVICE_BUILD} = true ]]; then
		export JAVA_HOME=${TERMUX__PREFIX__LIB_DIR}/jvm/java-25-openjdk
	fi
}

termux_step_make() {
	export PATH="$TERMUX_PKG_HOSTBUILD_DIR/ubuntu_packages/usr/bin:$PATH"
	ant
}

termux_step_make_install() {
	cp -r $TERMUX_PKG_SRCDIR/bin/libs/native/linux/arm64/org/lwjgl $TERMUX__PREFIX__LIB_DIR/lwjgl3
}
