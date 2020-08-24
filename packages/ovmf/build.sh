TERMUX_PKG_HOMEPAGE=https://www.tianocore.org/
TERMUX_PKG_DESCRIPTION="Open Virtual Machine Firmware"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_VERSION=20200515.1437.g5a6d764e1d
TERMUX_PKG_SRCURL=(https://www.kraxel.org/repos/jenkins/edk2/edk2.git-aarch64-0-${TERMUX_PKG_VERSION}.noarch.rpm
		   https://www.kraxel.org/repos/jenkins/edk2/edk2.git-ovmf-x64-0-${TERMUX_PKG_VERSION}.noarch.rpm)
TERMUX_PKG_SHA256=(e6adfe02417028901fac417b744df06b27a4bbf1f3b76068ac1917727829ad4d
		   c89ba5976e7b4a9f6d8ae5a9c5b7e29a20522a20f30b06131f126e7b7e776bc1) 
TERMUX_PKG_SKIP_SRC_EXTRACT=true

termux_step_make_install() {
	termux_download \
		${TERMUX_PKG_SRCURL[0]} \
		${TERMUX_PKG_CACHEDIR}/edk2-aarch64.rpm \
		${TERMUX_PKG_SHA256[0]}
	termux_download \
		${TERMUX_PKG_SRCURL[1]} \
		${TERMUX_PKG_CACHEDIR}/edk2-x86_64.rpm \
		${TERMUX_PKG_SHA256[1]}

	local i
	for i in aarch64 x86_64; do
		bsdtar xf ${TERMUX_PKG_CACHEDIR}/edk2-${i}.rpm -C $TERMUX_PREFIX
	done
}

termux_step_install_license() {
	install -Dm600 $TERMUX_PKG_BUILDER_DIR/License.txt \
		$TERMUX_PREFIX/share/doc/ovmf/LICENSE.txt
}
