TERMUX_PKG_HOMEPAGE=https://gohugo.io/
TERMUX_PKG_DESCRIPTION="A fast and flexible static site generator"
TERMUX_PKG_VERSION=0.53
TERMUX_PKG_SRCURL=https://github.com/gohugoio/hugo/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=48e65a33d3b10527101d13c354538379d9df698e5c38f60f4660386f4232e65c

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR

	cd $TERMUX_PKG_SRCDIR
	go install
}

termux_step_make_install() {
	install -Dm700 $GOPATH/bin/android_$GOARCH/hugo $TERMUX_PREFIX/bin/hugo

	# Seems that some files became RO-only
	# and should be manually removed.
	chmod 700 -R $GOPATH/pkg
	rm -rf $GOPATH/pkg
}
