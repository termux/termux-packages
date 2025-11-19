TERMUX_PKG_HOMEPAGE=https://www.tianocore.org/
TERMUX_PKG_DESCRIPTION="Open Virtual Machine Firmware"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="@termux"
_ED2K_VERSION=20231122
_FEDORA_REPO_VERSION=16.fc40
TERMUX_PKG_VERSION=$_ED2K_VERSION-$_FEDORA_REPO_VERSION
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_post_get_source() {
	# Borrowed from termux/termux-packages@840024d1d1446b36cc90ecce2aa0d8fb67368d8a
	# Array of strings of the form "NAME_SUFFIX RPM_SHA256":
	local _RPMS=()
	# Example:
	# _RPMS+=("SUFFIX 0000000000000000000000000000000000000000000000000000000000000000")
	_RPMS+=("aarch64      decddd49193087dfcb5cd31e9727f538249200894d0bdca9d7c77e76a2ad0b97") # aarch64
	_RPMS+=("arm          03bb429360aae4454716560cfe662812594405d9c43b0dd33d5a20a53f1bf813") # arm
	_RPMS+=("ovmf-ia32    867ae577c6bf6aa7977b147105b229f94238b26e1b78da8d7df79084e2eb47d4") # i686
	_RPMS+=("ovmf         eaecf688f69889fe6482857b169f540e72ccfff8e165d7a104a92f82274261b6") # x86_64
	_RPMS+=("riscv64      e7c6e7a7d052307fa696103bc6eb7076ddf36ed9f922edbf7d3f3f3ffae099b4") # riscv64
	_RPMS+=("ovmf-xen     3696a326ea5f68863426477335868c570a7911baee4086f372ff360c829fe6ec") # xen build
	_RPMS+=("experimental b1f2e2a2c30059f20f93e0d9fe39864892c472bee5e87cec47eb8f0f263b4677") # experimental build

	local _NUM_RPMS=${#_RPMS[@]}

	local i
	for i in $(seq 0 $((_NUM_RPMS-1))); do
		local _name_suffix=$(echo ${_RPMS[i]} | cut -d ' ' -f 1)
		local _rpm_sha256=$(echo ${_RPMS[i]} | cut -d ' ' -f 2)
		local _rpm_filename="edk2-$_name_suffix-$TERMUX_PKG_VERSION.noarch.rpm"
		termux_download \
			"https://kojipkgs.fedoraproject.org/packages/edk2/$_ED2K_VERSION/$_FEDORA_REPO_VERSION/noarch/$_rpm_filename" \
			"$TERMUX_PKG_CACHEDIR/${_rpm_filename}" \
			"${_rpm_sha256}"
	done
}

termux_step_make_install() {
	local _file
	for _file in ${TERMUX_PKG_CACHEDIR}/*.rpm; do
		bsdtar xf $_file -C $TERMUX_PREFIX/../
	done

	for _file in $TERMUX_PREFIX/share/qemu/firmware/*.json; do
		sed -i "s@/usr@$TERMUX_PREFIX@g" $_file
	done

	mkdir -p $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME
	mv $TERMUX_PREFIX/share/doc/edk2-ovmf/* $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/
	mv $TERMUX_PREFIX/share/doc/edk2-experimental/* $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/
}

termux_step_install_license() {
	mkdir -p $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME
	mv $TERMUX_PREFIX/share/licenses/edk2-ovmf/* $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/
}

termux_step_post_massage() {
	rm -rf share/licenses
}
