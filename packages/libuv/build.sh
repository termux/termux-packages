TERMUX_PKG_HOMEPAGE=http://libuv.org
TERMUX_PKG_DESCRIPTION="Support library with a focus on asynchronous I/O"
TERMUX_PKG_VERSION=1.13.0
TERMUX_PKG_SRCURL=http://dist.libuv.org/dist/v${TERMUX_PKG_VERSION}/libuv-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=708e51f8845e1728a2df50d2aa8438dbd97a48d4a86fcbbcdead0c406d710315

termux_step_pre_configure () {
	export PLATFORM=android
	sh autogen.sh
}
