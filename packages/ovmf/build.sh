TERMUX_PKG_HOMEPAGE=https://www.tianocore.org/
TERMUX_PKG_DESCRIPTION="Open Virtual Machine Firmware"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20210421.14.g5531fd48de
TERMUX_PKG_SRCURL=(https://www.kraxel.org/repos/jenkins/edk2/edk2.git-aarch64-0-${TERMUX_PKG_VERSION}.noarch.rpm
		   https://www.kraxel.org/repos/jenkins/edk2/edk2.git-arm-0-${TERMUX_PKG_VERSION}.noarch.rpm
		   https://www.kraxel.org/repos/jenkins/edk2/edk2.git-ovmf-ia32-0-${TERMUX_PKG_VERSION}.noarch.rpm
		   https://www.kraxel.org/repos/jenkins/edk2/edk2.git-ovmf-x64-0-${TERMUX_PKG_VERSION}.noarch.rpm)
TERMUX_PKG_SHA256=(17995b69b3eac21ba2cb27c0cbaf79ddb21b74b0588f9fd49c19e0c1ad2cec9c
		   f8b3e5ed0e81073841a08ac2a7fee9abe5dae7b4c2a8536a600aa86a383fb308
		   66206ddad3c6cc6ea370494934573627f0d9d6077924fd094c0bdd9bde3bf588
		   d0bd82a566fc162601fdd92f08b1b7df11a3f1d99bcb34171a80cb68b07140a7)
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	termux_download \
		${TERMUX_PKG_SRCURL[0]} \
		${TERMUX_PKG_CACHEDIR}/edk2-aarch64.rpm \
		${TERMUX_PKG_SHA256[0]}
	termux_download \
		${TERMUX_PKG_SRCURL[1]} \
		${TERMUX_PKG_CACHEDIR}/edk2-arm.rpm \
		${TERMUX_PKG_SHA256[1]}
	termux_download \
		${TERMUX_PKG_SRCURL[2]} \
		${TERMUX_PKG_CACHEDIR}/edk2-i686.rpm \
		${TERMUX_PKG_SHA256[2]}
	termux_download \
		${TERMUX_PKG_SRCURL[3]} \
		${TERMUX_PKG_CACHEDIR}/edk2-x86_64.rpm \
		${TERMUX_PKG_SHA256[3]}

	local i
	for i in aarch64 arm i686 x86_64; do
		bsdtar xf ${TERMUX_PKG_CACHEDIR}/edk2-${i}.rpm -C $TERMUX_PREFIX/../
	done

	for i in $TERMUX_PREFIX/share/qemu/firmware/*.json; do
		sed -i "s@/usr@$TERMUX_PREFIX@g" $i
	done
}

termux_step_install_license() {
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/License.txt \
		$TERMUX_PREFIX/share/doc/ovmf/LICENSE.txt
}
