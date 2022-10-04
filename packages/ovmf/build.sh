TERMUX_PKG_HOMEPAGE=https://www.tianocore.org/
TERMUX_PKG_DESCRIPTION="Open Virtual Machine Firmware"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20220719.209.gf0064ac3af
TERMUX_PKG_SRCURL=(https://www.kraxel.org/repos/jenkins/edk2/edk2.git-aarch64-0-${TERMUX_PKG_VERSION}.EOL.no.nore.updates.noarch.rpm
		   https://www.kraxel.org/repos/jenkins/edk2/edk2.git-arm-0-${TERMUX_PKG_VERSION}.EOL.no.nore.updates.noarch.rpm
		   https://www.kraxel.org/repos/jenkins/edk2/edk2.git-ovmf-ia32-0-${TERMUX_PKG_VERSION}.EOL.no.nore.updates.noarch.rpm
		   https://www.kraxel.org/repos/jenkins/edk2/edk2.git-ovmf-x64-0-${TERMUX_PKG_VERSION}.EOL.no.nore.updates.noarch.rpm)
TERMUX_PKG_SHA256=(879d6166029c5b26c300e8702e85ca5329b9103612ba6abb6018cb72be752c3f
		   1a70879806ea22ad2b167618e56fe3fc038905566e641197e2e35a48d7c76574
		   399430845c0630b559aa2cb169625daf3796a60af8c501786d8bafe8416d880c
		   bc42937c5c50b552dd7cd05ed535ed2b8aed30b04060032b7648ffeee2defb8e)
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
		$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/LICENSE.txt
}
