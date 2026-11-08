TERMUX_PKG_HOMEPAGE=https://www.call-cc.org
TERMUX_PKG_DESCRIPTION="A feature rich Scheme compiler and interpreter"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.1.0"
TERMUX_PKG_SRCURL="https://code.call-cc.org/releases/${TERMUX_PKG_VERSION}/chicken-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=c6aee9a5374102ba318e0cfae62ded5e1825346577137952d7fb15b3094d49d8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_DEPENDS="aosp-libs"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
CSC_PROGRAM=chicken-csc
CSI_PROGRAM=chicken-csi
PLATFORM=android
"

termux_step_pre_configure() {
	local ARCH="${TERMUX_ARCH/_/-}" # Replace '_' in x86_64 with '-'.
	if [[ "${TERMUX_ARCH}" == "i686" ]]; then
		ARCH="x86"
	fi
	TERMUX_PKG_EXTRA_MAKE_ARGS+=" ARCH=$ARCH LIBRARIAN=$AR"

	export C_COMPILER="$CC"

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		termux_setup_proot
	fi
}

# chicken's configuration is not autoconf.
# It tries to test compiler by running a program which fails.
# But we can bypass configure and pass relevant options directly to make.
termux_step_configure() { :; }

termux_step_post_make_install() {
	local termux_proot_run=''
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		termux_proot_run=termux-proot-run
	fi
	$termux_proot_run "$TERMUX_PREFIX/bin/chicken-install" -defaults ./setup.defaults -update-db
}
