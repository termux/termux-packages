TERMUX_PKG_HOMEPAGE=https://github.com/Crixec/ADBToolKitsInstaller
TERMUX_PKG_DESCRIPTION="ADB tools for Android"
TERMUX_PKG_VERSION=1.1

termux_step_make_install () {
case "$TERMUX_ARCH" in
aarch64 | arm ) ;;
x86_64  | i686 ) ;;
* ) echo "Unsupported arch: $TERMUX_ARCH"; exit 1 ;;
esac

local adb_prebuilt="adb-prebuilt-${TERMUX_ARCH}"
local fastboot_prebuilt="fastboot-prebuilt-${TERMUX_ARCH}"
     cp -p $TERMUX_PKG_BUILDER_DIR/$adb_prebuilt $TERMUX_PREFIX/bin/adb
     cp -p $TERMUX_PKG_BUILDER_DIR/$fastboot_prebuilt $TERMUX_PREFIX/bin/fastb>
}
