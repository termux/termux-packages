TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://tox.chat
TERMUX_PKG_DESCRIPTION="Backend library for the Tox protocol"
TERMUX_PKG_VERSION=0.2.5
TERMUX_PKG_SRCURL=https://github.com/TokTok/toxcore/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9ad8a3b3dac80e0a46087fd1f7895819f22494e6b687d68e4a779eeff21ad2d8
TERMUX_PKG_DEPENDS="libsodium"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	termux_setup_cmake

	cmake \
			-DCMAKE_INSTALL_PREFIX="${TERMUX_PREFIX}" \
			-DCMAKE_INSTALL_LIBDIR="${TERMUX_PREFIX}/lib" \
			-DBOOTSTRAP_DAEMON=off \
			-DDHT_BOOTSTRAP=off \
			-DBUILD_TOXAV=off \
			-DBUILD_AV_TEST=off
}
