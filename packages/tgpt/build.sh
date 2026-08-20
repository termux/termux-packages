TERMUX_PKG_HOMEPAGE=https://github.com/aandrew-me/tgpt
TERMUX_PKG_DESCRIPTION="AI Chatbots in terminal without needing API keys"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.13.0"
TERMUX_PKG_SRCURL=https://github.com/aandrew-me/tgpt/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=950af3b39f5870d0659c88ae195b46553580e5d96c31f2230b7eb159d774e7b4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	# Vendor and sanitize go modules ahead of patching step.
	termux_setup_golang
	go mod tidy
	go mod vendor

	# golang's "mobile" module contains both code
	# related to SurfaceFlinger(ANativeWindow[For Building an APK]),
	# and also X11-related code that upstream connects to "linux && !android".
	# apply the pattern "treat Android as linux" here,
	# to force the disabling of the SurfaceFlinger-dependent
	# code and the enabling of the X11-related code,
	# fixing the error when building using NDK r28c:
	# android.c:171:52: error: incompatible pointer to integer conversion
	# passing 'ANativeWindow *' (aka 'struct ANativeWindow *') to parameter
	# of type 'EGLNativeWindowType' (aka 'unsigned long') [-Wint-conversion]
	find \
		vendor/golang.org/x/mobile \
		-type f -print0 | \
		xargs -0 -n 1 sed -i \
		-e 's|build android|build disabling_this_because_it_is_for_building_an_apk|g' \
		-e 's|linux && !android|linux|g' \
		-e 's|linux,!android|linux|g'
}

termux_step_make() {
	go build -trimpath -ldflags="-s -w"
}

termux_step_make_install() {
	install -Dm700 tgpt "$TERMUX_PREFIX"/bin/tgpt
}
