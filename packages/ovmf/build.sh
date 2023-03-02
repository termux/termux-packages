TERMUX_PKG_HOMEPAGE=https://www.tianocore.org/
TERMUX_PKG_DESCRIPTION="Open Virtual Machine Firmware"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="@termux"
_ED2K_VERSION=20221117gitfff6d81270b5
_FEDORA_REPO_VERSION=14.fc39
TERMUX_PKG_VERSION=$_ED2K_VERSION-$_FEDORA_REPO_VERSION
TERMUX_PKG_SRCURL=(https://kojipkgs.fedoraproject.org/packages/edk2/$_ED2K_VERSION/$_FEDORA_REPO_VERSION/noarch/edk2-aarch64-$TERMUX_PKG_VERSION.noarch.rpm
		   https://kojipkgs.fedoraproject.org/packages/edk2/$_ED2K_VERSION/$_FEDORA_REPO_VERSION/noarch/edk2-arm-$TERMUX_PKG_VERSION.noarch.rpm
		   https://kojipkgs.fedoraproject.org/packages/edk2/$_ED2K_VERSION/$_FEDORA_REPO_VERSION/noarch/edk2-ovmf-ia32-$TERMUX_PKG_VERSION.noarch.rpm
		   https://kojipkgs.fedoraproject.org/packages/edk2/$_ED2K_VERSION/$_FEDORA_REPO_VERSION/noarch/edk2-ovmf-$TERMUX_PKG_VERSION.noarch.rpm)
TERMUX_PKG_SHA256=(deeea32e2ee7ffdd3a0b8a4a215dba50a0553128f7a21c27ec0929ed7a06d3e5
		   dcc58da8c71fec992229ac629248802ffa71c4ef84ffa5b2df32dcf0fe56f6e4
		   08ade311bde8b6a80b6aa138746949a6972a62c2976e0965a9be7127afac94f9
		   5d4013dbdb7838227f3863514b61079a696e34f41492c66f437ec1a38afb06ea)
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
	mkdir -p $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME
	mv $TERMUX_PREFIX/share/licenses/edk2-ovmf/* $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/
}

termux_step_post_massage() {
	rm -rf share/licenses
}
