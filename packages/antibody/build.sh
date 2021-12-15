TERMUX_PKG_HOMEPAGE=https://github.com/getantibody/antibody
TERMUX_PKG_DESCRIPTION="The fastest shell plugin manager"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.1.1
TERMUX_PKG_SRCURL=https://github.com/getantibody/antibody/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=87bced5fba8cf5d587ea803d33dda72e8bcbd4e4c9991a9b40b2de4babbfc24f
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	mkdir -p "$GOPATH"/src/github.com/getantibody
	ln -sf "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/github.com/getantibody/antibody

	cd "$GOPATH"/src/github.com/getantibody/antibody
	go build
}

termux_step_make_install() {
	install -Dm700 \
		"$GOPATH"/src/github.com/getantibody/antibody/antibody \
		"$TERMUX_PREFIX"/bin/
}
