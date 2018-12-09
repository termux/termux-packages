TERMUX_PKG_HOMEPAGE=https://sourceware.org/lvm2/
TERMUX_PKG_DESCRIPTION="A device-mapper library from LVM2 package"
TERMUX_PKG_DEPENDS="libandroid-support"
TERMUX_PKG_VERSION=2.03.00
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/sourceware/lvm2/releases/LVM2.${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=405992bf76960e60c7219d84d5f1e22edc34422a1ea812e21b2ac3c813d0da4e
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make() {
    make -j"${TERMUX_MAKE_PROCESSES}" lib.device-mapper
}

termux_step_make_install() {
    cd libdm
    make install
}

