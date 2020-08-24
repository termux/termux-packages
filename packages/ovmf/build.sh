TERMUX_PKG_HOMEPAGE=https://www.tianocore.org/
TERMUX_PKG_DESCRIPTION="A modern, feature-rich, cross-platform firmware development environment for the UEFI and PI specifications from www.uefi.org."
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="License.txt"
TERMUX_PKG_VERSION=()
TERMUX_PKG_VERSION+=(20200515.1437.g5a6d764e1d)
TERMUX_PKG_SRCURL=(https://www.kraxel.org/repos/jenkins/edk2/edk2.git-aarch64-0-${TERMUX_PKG_VERSION}.noarch.rpm
		   https://www.kraxel.org/repos/jenkins/edk2/edk2.git-ovmf-x64-0-${TERMUX_PKG_VERSION}.noarch.rpm)
TERMUX_PKG_SHA256=(e6adfe02417028901fac417b744df06b27a4bbf1f3b76068ac1917727829ad4d
		   c89ba5976e7b4a9f6d8ae5a9c5b7e29a20522a20f30b06131f126e7b7e776bc1) 
#TERMUX_PKG_BUILD_IN_SRC=true


termux_step_extract_package() {
	mkdir $TERMUX_PKG_SRCDIR
	cd TERMUX_PKG_CACHEDIR
	bsdtar -xf "edk2.git-aarch64-0-${TERMUX_PKG_VERSION}.noarch.rpm"-C $TERMUX_PKG_SRCDIR
	bsdtar -xf edk2.git-ovmf-x64-0-${TERMUX_PKG_VERSION}.noarch.rpm -C $TERMUX_PKG_SRCDIR
}
