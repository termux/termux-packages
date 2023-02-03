TERMUX_PKG_HOMEPAGE=https://github.com/DrakeW/corgi
TERMUX_PKG_DESCRIPTION="CLI workflow manager"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.2.4"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/DrakeW/corgi/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=783fa88c29aecfbd8a557c186cee4d2f41927a3147464d4ccabb99600e3a02e6
TERMUX_PKG_RECOMMENDS="fzf"
TERMUX_PKG_SUGGESTS="peco"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_post_get_source() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_SRCDIR/go
	go mod init main.go
	go get
	chmod +w $GOPATH -R
}

termux_step_make() {
	export GOPATH=$TERMUX_PKG_SRCDIR/go
	go build -o corgi
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin "$TERMUX_PKG_SRCDIR"/corgi
}

termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX"/etc/profile.d
	cat <<- EOF > "$TERMUX_PREFIX"/etc/profile.d/corgi.sh
	#!$TERMUX_PREFIX/bin/sh
	export HISTFILE=\$SHELL
	EOF
}
