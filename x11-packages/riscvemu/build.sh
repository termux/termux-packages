TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://bellard.org/riscvemu/
TERMUX_PKG_DESCRIPTION="RISC-V system emulator"
_COMMIT=d81d3be5b15ae8506668bace1cde82cf0e04a26e
TERMUX_PKG_VERSION=20170806
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://github.com/xeffyr/riscvemu/archive/${_COMMIT}.tar.gz
TERMUX_PKG_SHA256=a1c806f8436fb82fa49accc337263bf65292f7d92edd8ab94624c3e816502a87

TERMUX_PKG_DEPENDS="libcurl, openssl, sdl"
TERMUX_PKG_CONFLICTS="riscvemu-sdl"
TERMUX_PKG_REPLACES="riscvemu-sdl"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DUSE_NETWORK_FILESYSTEM=y
-DUSE_SLIRP_NETWORKING=y
-DUSE_SDL_GRAPHICS=y
-DINSTALL_SAMPLES=y
"

termux_step_post_make_install() {
    ln -sfr "${TERMUX_PREFIX}/bin/riscvemu64" "${TERMUX_PREFIX}/bin/riscvemu"
}

termux_step_create_debscripts() {
    cp "${TERMUX_PKG_BUILDER_DIR}/postinst" ./
}
