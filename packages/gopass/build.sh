TERMUX_PKG_HOMEPAGE=https://github.com/gopasspw/gopass
TERMUX_PKG_DESCRIPTION="The slightly more awesome standard unix password manager for teams"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="1.17.0"
TERMUX_PKG_SRCURL=https://github.com/gopasspw/gopass/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ce004c82b65ffac44de2991020843828b38bb510909506f2fa0f40bec05b7c75
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="git, gnupg"
TERMUX_PKG_SUGGESTS="termux-api, openssh"

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
	termux_setup_golang
	# The commit introducing this is 2 years old, no idea why its only causing build failures now
	# https://github.com/gopasspw/gopass/commit/ffaa9e372999a4c5db82f0a281fc67758d107ac0
	# needed as of 1.15.13 for all architectures except AArch64
	sed -i 's|CGO_ENABLED=0|CGO_ENABLED=1|g' "$TERMUX_PKG_SRCDIR/Makefile"
	export GOPATH=$TERMUX_PKG_BUILDDIR

	mkdir -p ./src
	mkdir -p ./src/github.com/gopasspw
	ln -sf "$TERMUX_PKG_SRCDIR" ./src/github.com/gopasspw/gopass

	rm -f ./src/github.com/gopasspw/gopass/gopass
	make -C ./src/github.com/gopasspw/gopass build CLIPHELPERS="-X github.com/gopasspw/gopass/pkg/clipboard.Helpers=termux-api'"
	install -Dm700 \
		./src/github.com/gopasspw/gopass/gopass \
		"$TERMUX_PREFIX"/bin/gopass
}

termux_step_post_make_install() {
	cd "$TERMUX_PKG_SRCDIR"
	install -Dm600 gopass.1 -t "$TERMUX_PREFIX/share/man/man1"
	install -Dm600 bash.completion "$TERMUX_PREFIX/share/bash-completion/completions/gopass"
	install -Dm600 zsh.completion "$TERMUX_PREFIX/share/zsh/site-functions/_gopass"
	install -Dm600 fish.completion "$TERMUX_PREFIX/share/fish/vendor_completions.d/gopass.fish"
	install -Dm600 {README,CHANGELOG,ARCHITECTURE}.md -t "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME"
	cd ./docs
	rm -f logo*.*
	cp --parents -r * -t "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME"
}
