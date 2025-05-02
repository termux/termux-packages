TERMUX_PKG_HOMEPAGE=https://github.com/fcitx/fcitx5-chinese-addons
TERMUX_PKG_DESCRIPTION="Addons related to Chinese, including IME previous bundled inside fcitx4"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.1.8"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL="https://github.com/fcitx/fcitx5-chinese-addons/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=0182025f7451adb2df488812b31b900dfb59fb264a6b485fa2339e8ecd63bb41
TERMUX_PKG_DEPENDS="boost, fcitx5, fcitx5-qt, libc++, libcurl, libime, libopencc, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="aosp-libs, boost-headers, extra-cmake-modules"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_BROWSER=OFF
-DENABLE_DATA=OFF
-DENABLE_TEST=OFF
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		termux_setup_proot
		patch -p1 -i "$TERMUX_PKG_BUILDER_DIR"/im-pinyin-CMakeLists.txt.diff
	fi
}

termux_step_post_make_install() {
	echo -e "termux - building fcitx5-chinese-addons dictionary..."
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=' -DENABLE_DATA=ON'
	termux_step_configure
	termux_step_make

	# from add_custom_commands in im/pinyin/CMakeLists.txt
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		pushd im/pinyin
		termux-proot-run "${TERMUX_PREFIX}"/bin/libime_pinyindict "${TERMUX_PKG_SRCDIR}"/im/pinyin/chaizi.txt chaizi.dict
		popd
	fi

	termux_step_make_install
}
