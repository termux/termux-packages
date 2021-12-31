TERMUX_PKG_HOMEPAGE=https://www.tianocore.org/
TERMUX_PKG_DESCRIPTION="Open Virtual Machine Firmware"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20211216.94.gb451c69088
TERMUX_PKG_SRCURL=(https://www.kraxel.org/repos/jenkins/edk2/edk2.git-aarch64-0-${TERMUX_PKG_VERSION}.noarch.rpm
		   https://www.kraxel.org/repos/jenkins/edk2/edk2.git-arm-0-${TERMUX_PKG_VERSION}.noarch.rpm
		   https://www.kraxel.org/repos/jenkins/edk2/edk2.git-ovmf-ia32-0-${TERMUX_PKG_VERSION}.noarch.rpm
		   https://www.kraxel.org/repos/jenkins/edk2/edk2.git-ovmf-x64-0-${TERMUX_PKG_VERSION}.noarch.rpm)
TERMUX_PKG_SHA256=(c54da54841de2873e822aae1775c21161cb276b984d2d64ed698bb126b9e114c
		   007b3b02b16dafa48a78be52d10991ebd93180bb2aae24a3f574cba567f546c2
		   937fc34e2663ff561b49784043092b3cfa510a6f74a47b22f627c2183bf31272
		   79dcf24dd261b6317b47fdba71926e42eec2d622a8debbee9e88fe07b8aeb8a5)
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
