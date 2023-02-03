TERMUX_PKG_HOMEPAGE=https://github.com/Canop/broot
TERMUX_PKG_DESCRIPTION="A better way to navigate directories"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.20.0
TERMUX_PKG_SRCURL=https://github.com/Canop/broot/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4637dfb91575ad6da36ab32f10ea5d363709587f7cf2e728fab25b2c73d30311
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CPPFLAGS+=" -DGIT_ERROR_SHA1=GIT_ERROR_SHA"

	termux_setup_rust

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo fetch --target "${CARGO_TARGET_NAME}"

	local _patch=$TERMUX_SCRIPTDIR/packages/libgit2/src-util-rand.c.patch
	local d
	for d in $CARGO_HOME/registry/src/github.com-*/libgit2-sys-*/libgit2; do
		(
			t=${d}/src/
			cp $TERMUX_SCRIPTDIR/packages/libgit2/getloadavg.c ${t}
			patch --silent -d ${t} < ${_patch}
		) || :
	done
}

termux_step_make() {
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release

	mkdir -p build
	cp man/page build/broot.1
	sed -i "s/#version/$TERMUX_PKG_VERSION/g" build/broot.1
	sed -i "s/#date/$(date -r man/page +'%Y\/%m\/%d')/g" build/broot.1

}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/broot
	install -Dm644 -t $TERMUX_PREFIX/share/man/man1 build/broot.1
}
