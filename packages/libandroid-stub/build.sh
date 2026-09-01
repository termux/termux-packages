TERMUX_PKG_HOMEPAGE=https://android.googlesource.com/platform/frameworks/base/+/main/native/android
TERMUX_PKG_DESCRIPTION="Stub libandroid.so for non-Android certified environment"
TERMUX_PKG_LICENSE="NCSA"
TERMUX_PKG_MAINTAINER="@termux"
# Version should be equal to TERMUX_NDK_{VERSION_NUM,REVISION} in
# scripts/properties.sh
TERMUX_PKG_VERSION=29
TERMUX_PKG_REVISION=3
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_CONFLICTS="libandroid"
TERMUX_PKG_REPLACES="libandroid"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_API_LEVEL=28

termux_step_make() {
	local common_flags=(
		$CFLAGS $LDFLAGS
		-Wno-deprecated-declarations
		-Wl,--no-use-android-relr-tags
		-Wl,--pack-dyn-relocs=android
	)

	# The wrappers share a single namespace, so that a process is never left
	# with two copies of libbinder.so and thus two ProcessState singletons.
	"${CC}" -shared -fPIC \
		-o "${TERMUX_PREFIX}/lib/libtermux-platform-ns.so" \
		"${TERMUX_PKG_BUILDER_DIR}/platform-ns.c" \
		"${common_flags[@]}"

	local stub
	for stub in android mediandk OpenSLES binder_ndk; do
		"${CC}" -shared -fPIC \
			-o "${TERMUX_PREFIX}/lib/lib${stub}.so" \
			"${TERMUX_PKG_BUILDER_DIR}/lib${stub}-wrapper.c" \
			-I"${TERMUX_PKG_BUILDER_DIR}" \
			"${common_flags[@]}" \
			-ltermux-platform-ns
	done
}
