TERMUX_PKG_HOMEPAGE=https://zrok.io/
TERMUX_PKG_DESCRIPTION="An open source sharing solution built on OpenZiti."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.4.48"
TERMUX_PKG_SRCURL=https://github.com/openziti/zrok/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0b748e2f5cffeb4cd975d94b45aef99b4d929c2b6ad4615846f95fb53bb33355
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_configure() {
	:
}

termux_step_make() {
	termux_setup_nodejs
	termux_setup_golang

	pushd ui
	cd "$TERMUX_PKG_SRCDIR/ui"
	npm install
	npm run build
	popd

	mkdir -p  "$TERMUX_PKG_SRCDIR/dist"

	export GOPATH="$TERMUX_PKG_BUILDDIR"
	export LDFLAGS="-s -w -X main.VERSION=${TERMUX_PKG_VERSION}"
	go build -o dist ./...
}

termux_step_make_install() {
	# I have taken the liberty to give the binaries less generic names.
	install -Dm700 $TERMUX_PKG_SRCDIR/dist/copyto $TERMUX_PREFIX/bin/zrok-cp
	install -Dm700 $TERMUX_PKG_SRCDIR/dist/http-server $TERMUX_PREFIX/bin/zrok-server
	install -Dm700 $TERMUX_PKG_SRCDIR/dist/pastefrom $TERMUX_PREFIX/bin/zrok-paste
	install -Dm700 $TERMUX_PKG_SRCDIR/dist/zrok $TERMUX_PREFIX/bin/zrok
}

termux_step_create_debscripts() {
	# Give proper notice that the generically named
	# ancillary binaries have been renamed
	cat <<- POSTINST_EOF > ./postinst
	#!$TERMUX_PREFIX/bin/bash
		echo "Some of Zrok's binaries have been renamed in this package!"
		echo "copyto -> zrok-cp"
		echo "pastefrom -> zrok-paste"
		echo "http-server -> zrok-server"
		echo
		echo "The main zrok binary is unchanged"
		echo "and the usage of the ancillary binaries is unchanged"
		echo "except for the name."
	exit 0
	POSTINST_EOF

	chmod 0755 postinst

	if [[ "$TERMUX_PACKAGE_FORMAT" == "pacman" ]]; then
		echo "post_install" > postupg
	fi
}
