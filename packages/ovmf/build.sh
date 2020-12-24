TERMUX_PKG_HOMEPAGE=https://www.tianocore.org/
TERMUX_PKG_DESCRIPTION="Open Virtual Machine Firmware"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20201222.1526.ge2747dbb5a
TERMUX_PKG_SRCURL=(https://www.kraxel.org/repos/jenkins/edk2/edk2.git-aarch64-0-${TERMUX_PKG_VERSION}.noarch.rpm
		   https://www.kraxel.org/repos/jenkins/edk2/edk2.git-arm-0-${TERMUX_PKG_VERSION}.noarch.rpm
		   https://www.kraxel.org/repos/jenkins/edk2/edk2.git-ovmf-ia32-0-${TERMUX_PKG_VERSION}.noarch.rpm
		   https://www.kraxel.org/repos/jenkins/edk2/edk2.git-ovmf-x64-0-${TERMUX_PKG_VERSION}.noarch.rpm)
TERMUX_PKG_SHA256=(605a26ccf228d0577c4095d2549c94b145978373e26b2d6eb845457901d249e7
		   04118ec32022c8469b96b0c4b9cbecf02db8caa925377b035baece303ca1997d
		   0df2deac39bf0045f0827400291686d81280c0f2769bef67701a50fe070b44b5
		   021825fe51fbf07d1ed3b0fd8cd0d2da491155c23338495e5b1dc8f4641c96bb)
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
		${TERMUX_PKG_CACHEDIR}/edk2-ia32.rpm \
		${TERMUX_PKG_SHA256[2]}
	termux_download \
		${TERMUX_PKG_SRCURL[3]} \
		${TERMUX_PKG_CACHEDIR}/edk2-x86_64.rpm \
		${TERMUX_PKG_SHA256[3]}

	local i
	for i in aarch64 arm ia32 x86_64; do
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
