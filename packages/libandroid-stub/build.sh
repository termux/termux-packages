TERMUX_PKG_HOMEPAGE=https://android.googlesource.com/platform/frameworks/base/+/main/native/android
TERMUX_PKG_DESCRIPTION="Stub libandroid.so for non-Android certified environment"
TERMUX_PKG_LICENSE="NCSA"
TERMUX_PKG_MAINTAINER="@termux"
# Version should be equal to TERMUX_NDK_{VERSION_NUM,REVISION} in
# scripts/properties.sh
TERMUX_PKG_VERSION=28c
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_CONFLICTS="libandroid"
TERMUX_PKG_REPLACES="libandroid"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_API_LEVEL=28

termux_step_make() {
	"${CC}" -shared -fPIC -o "${TERMUX_PREFIX}/lib/libandroid.so" "$TERMUX_PKG_BUILDER_DIR/libandroid-wrapper.c" -Wno-deprecated-declarations
	"${CC}" -shared -fPIC -o "${TERMUX_PREFIX}/lib/libmediandk.so" "$TERMUX_PKG_BUILDER_DIR/libmediandk-wrapper.c" -Wno-deprecated-declarations
	"${CC}" -shared -fPIC -o "${TERMUX_PREFIX}/lib/libOpenSLES.so" "$TERMUX_PKG_BUILDER_DIR/libOpenSLES-wrapper.c" -Wno-deprecated-declarations
}
