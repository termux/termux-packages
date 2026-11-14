TERMUX_PKG_HOMEPAGE=https://github.com/java-native-access/jna
TERMUX_PKG_DESCRIPTION="Java Native Access"
TERMUX_PKG_LICENSE="Apache-2.0, LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@CosmyBeyondStars"
TERMUX_PKG_VERSION="5.19.1"
TERMUX_PKG_SRCURL="https://github.com/java-native-access/jna/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=33a9e27b5a6eaa024bb117325392d1ccba7ca63f95d201230ad7c33d60f54c23
TERMUX_PKG_DEPENDS="openjdk-21, openjdk-21-x"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_EXTRA_MAKE_ARGS="
DYNAMIC_LIBFFI=true
"

termux_step_host_build() {
	local -a ubuntu_packages=(libffi8)
	if ! command -v ant; then
		ubuntu_packages+=(ant)
	fi
	termux_download_ubuntu_packages "${ubuntu_packages[@]}"
}

termux_step_pre_configure() {
	if [[ ${TERMUX_ON_DEVICE_BUILD} = true ]]; then
		export JAVA_HOME="${TERMUX__PREFIX__LIB_DIR}"/jvm/java-21-openjdk
	fi
}

termux_step_make() {
	export PATH="$TERMUX_PKG_HOSTBUILD_DIR/ubuntu_packages/usr/bin:$PATH"
	ant native $TERMUX_PKG_EXTRA_MAKE_ARGS
}

termux_step_make_install() {
	mkdir -p "${TERMUX__PREFIX__LIB_DIR}"/jna
	cp "$TERMUX_PKG_SRCDIR/build/native-linux-${TERMUX_ARCH/_/-}"/*.so "${TERMUX__PREFIX__LIB_DIR}"/jna/"
	cp "$TERMUX_PKG_SRCDIR/build/classes/com/sun/jna/linux-${TERMUX_ARCH/_/-}/libjnidispatch.so" "${TERMUX__PREFIX__LIB_DIR}"/jna/"
}
