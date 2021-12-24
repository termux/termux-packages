TERMUX_PKG_HOMEPAGE=https://github.com/cswl/tsu
TERMUX_PKG_DESCRIPTION="A su wrapper for Termux"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=8.6.0
_COMMIT=800b448becafb0186eecc366c50442ed9f8bb944
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SRCURL=https://github.com/cswl/tsu.git
TERMUX_PKG_GIT_BRANCH=v8

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT
}

termux_step_make() {
	python3 ./extract_usage.py
}

termux_step_make_install() {
	# There is no install.sh script in the repository for now
	mkdir -p "$TERMUX_PREFIX/bin"
	install -Dm755 tsu "$TERMUX_PREFIX/bin"
	# sudo - is an included addon in tsu now
	ln -sf "$TERMUX_PREFIX/bin/tsu" "$TERMUX_PREFIX/bin/sudo"
}
