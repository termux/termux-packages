TERMUX_PKG_HOMEPAGE=https://github.com/ayntgl/discordo
TERMUX_PKG_DESCRIPTION="A lightweight, secure, and feature-rich Discord terminal client"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=05fb80f88970e310e5c93d0a68dbe7c32180ebac
TERMUX_PKG_VERSION=2022.08.12
TERMUX_PKG_SRCURL=git+https://github.com/ayntgl/discordo
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_SHA256=2728f592186909e5f837aa5780594ba4d120eab20ab9be9b93622afcd169ba91
TERMUX_PKG_DEPENDS="golang"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	go build -trimpath -buildmode=pie -ldflags "-s -w" .
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin "$TERMUX_PKG_SRCDIR"/discordo
}
