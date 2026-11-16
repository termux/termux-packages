TERMUX_PKG_HOMEPAGE=https://github.com/veracrypt/VeraCrypt
TERMUX_PKG_DESCRIPTION="VeraCrypt disk encryption manager for Termux"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="License.txt"
TERMUX_PKG_MAINTAINER="Infiniti151 <43163551+Infiniti151@users.noreply.github.com>"
TERMUX_PKG_VERSION="1.26.31"
TERMUX_PKG_SRCURL="https://github.com/veracrypt/VeraCrypt/releases/download/VeraCrypt_${TERMUX_PKG_VERSION}/VeraCrypt_${TERMUX_PKG_VERSION}_Source.tar.bz2"
TERMUX_PKG_SHA256=6e9447c63a3a9c6f2b17ae4341caf973ed327bf7c9458b7d0c8f4f7b20a62da2
TERMUX_PKG_DEPENDS="libfuse3, libpcsclite, libdevmapper, wxwidgets"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	WX_FLAGS="$("$TERMUX_PREFIX/bin/wx-config" --cxxflags)"
	local EXTRA_MAKE_FLAGS=""
	local EXTRA_CFLAGS=""

	if [[ "$TERMUX_ARCH" == "aarch64" ]]; then
		# -Oz causes Crypto++ CPU_QueryAES/CPU_QuerySHA2 linker failures.
		ARM_FLAGS="-march=armv8-a+crypto -O2"
	fi

	if [[ "$TERMUX_ARCH" == "i686" ]]; then
		# Android forbids text relocations from non-PIC x86 assembly.
		EXTRA_MAKE_FLAGS="NOASM=1 NOAESNI=1"
		EXTRA_CFLAGS="-DCRYPTOPP_DISABLE_SHANI  -DCRYPTOPP_DISABLE_AESNI"
	fi

	# Prevent execution on host
	sed -i 's|./$(APPNAME)|true|g' Main/Main.make

	# Neutralize strip everywhere
	sed -i 's|\bstrip\b|true|g' Main/Main.make

	make -j$TERMUX_PKG_MAKE_PROCESSES \
		WITHFUSE3=1 \
		ARCH=$TERMUX_ARCH \
		PLATFORM_ARCH=$TERMUX_ARCH \
		WX_CONFIG="$TERMUX_PREFIX/bin/wx-config" \
		TC_EXTRA_CFLAGS="$CFLAGS $WX_FLAGS ${ARM_FLAGS-} ${EXTRA_CFLAGS-}" \
		TC_EXTRA_CXXFLAGS="$CXXFLAGS $WX_FLAGS ${ARM_FLAGS-} ${EXTRA_CFLAGS-}" \
		TC_EXTRA_LFLAGS="$LDFLAGS" \
		$EXTRA_MAKE_FLAGS
}

termux_step_make_install() {
	install -Dm755 "Main/veracrypt" "$TERMUX_PREFIX/bin/veracrypt"
}
