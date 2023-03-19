TERMUX_PKG_HOMEPAGE=https://justine.lol/blinkenlights/
TERMUX_PKG_DESCRIPTION="Tiniest x86-64-linux emulator"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.2"
TERMUX_PKG_SRCURL=https://github.com/jart/blink/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=38757098cdc9822399fe6eedb9529cc8c79ee44396bbecddce65fb9b7bbb47f9
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--prefix=${TERMUX_PREFIX}
--enable-ancillary
--enable-backtrace
--enable-bcd
--enable-disassembler
--enable-fork
--enable-jit
--enable-metal
--enable-mmx
--enable-nonposix
--enable-overlays
--enable-sockets
--enable-strace
--enable-threads
--enable-x87
"

termux_step_configure() {
	# custom configure script that errors
	# instead of ignores unknown arguments
	# also run tests on host rather than target
	# which gives wrong result
	./configure ${TERMUX_PKG_EXTRA_CONFIGURE_ARGS} \
		#--enable-bmi2 \
		#--pedantic \

	echo "========== config.log =========="
	cat config.log
	echo "========== config.log =========="
	echo "========== config.h =========="
	cat config.h
	echo "========== config.h =========="
	echo "========== config.mk =========="
	cat config.mk
	echo "========== config.mk =========="
}
