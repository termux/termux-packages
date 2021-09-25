TERMUX_PKG_HOMEPAGE=http://x265.org/
TERMUX_PKG_DESCRIPTION="H.265/HEVC video stream encoder library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.5
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://bitbucket.org/multicoreware/x265_git/downloads/x265_$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e70a3335cacacbba0b3a20ec6fecd6783932288ebc8163ad74bcc9606477cae8
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BREAKS="libx265-dev"
TERMUX_PKG_REPLACES="libx265-dev"

termux_step_pre_configure() {
	local ARM_ARGS

	# Not sure if this is necessary for on-device build
	ARM_ARGS="-fno-integrated-as"

	# Not sure if this is necessary for on-device build
	# Follow termux_step_configure_cmake.sh for now
	if [ "$TERMUX_ON_DEVICE_BUILD" = false ]; then
		ARM_ARGS+=" --target=${CCTERMUX_HOST_PLATFORM}"
	fi

	if [ "$TERMUX_ARCH" = i686 ]; then
		# Avoid text relocations.
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DENABLE_ASSEMBLY=OFF"
	elif [ "$TERMUX_ARCH" = arm ]; then
		# Follow termux_step_setup_toolchain.sh
		ARM_ARGS+=" -march=armv7-a -mfpu=neon -mfloat-abi=softfp -mthumb"
		# Avoid text relocations.
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DENABLE_ASSEMBLY=OFF"
	fi

	TERMUX_PKG_SRCDIR="$TERMUX_PKG_SRCDIR/source"

	sed -i "s/@ARM_ARGS@/${ARM_ARGS}/" \
		${TERMUX_PKG_SRCDIR}/CMakeLists.txt
}
