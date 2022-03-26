TERMUX_PKG_HOMEPAGE=https://starship.rs
TERMUX_PKG_DESCRIPTION="A minimal, blazing fast, and extremely customizable prompt for any shell"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.4
TERMUX_PKG_SRCURL=https://github.com/starship/starship/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=158003cd192f9375e504b9ab84d9239a06a8f9732cdd201243ab2fdcd38043f8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--no-default-features --features http"

termux_step_pre_configure() {
	termux_setup_rust
	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo fetch --target $CARGO_TARGET_NAME

	local d
	for d in $CARGO_HOME/registry/src/github.com-*/libgit2-sys-*/libgit2; do
		patch --silent -p1 -d ${d} \
			< $TERMUX_SCRIPTDIR/packages/libgit2/src-rand.c.patch || :
		cp $TERMUX_SCRIPTDIR/packages/libgit2/getloadavg.c ${d}/src/ || :
	done

	CFLAGS+=" $CPPFLAGS"
	if [ $TERMUX_ARCH = arm ]; then
		CFLAGS+=" -fno-integrated-as"
	fi

	mv $TERMUX_PREFIX/lib/libz.so.1{,.tmp}
	mv $TERMUX_PREFIX/lib/libz.so{,.tmp}

	local _CARGO_TARGET_LIBDIR=target/$CARGO_TARGET_NAME/release/deps
	mkdir -p $_CARGO_TARGET_LIBDIR
	ln -sfT $(readlink -f $TERMUX_PREFIX/lib/libz.so.1.tmp) \
		$_CARGO_TARGET_LIBDIR/libz.so.1
	ln -sfT $(readlink -f $TERMUX_PREFIX/lib/libz.so.tmp) \
		$_CARGO_TARGET_LIBDIR/libz.so
}

termux_step_make() {
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target ${CARGO_TARGET_NAME} --release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/starship
}

termux_step_post_make_install() {
	mv $TERMUX_PREFIX/lib/libz.so.1{.tmp,}
	mv $TERMUX_PREFIX/lib/libz.so{.tmp,}
}

termux_step_post_massage() {
	rm -f lib/libz.so.1
	rm -f lib/libz.so
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	mkdir -p $TERMUX_PREFIX/share/bash-completions/completions
	mkdir -p $TERMUX_PREFIX/share/fish/vendor_completions.d
	mkdir -p $TERMUX_PREFIX/share/zsh/site-functions

	starship completions bash > $TERMUX_PREFIX/share/bash-completions/completions/starship
	starship completions fish > $TERMUX_PREFIX/share/fish/vendor_completions.d/starship.fish
	starship completions zsh > $TERMUX_PREFIX/share/zsh/site-functions/_starship
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	rm -f $TERMUX_PREFIX/share/bash-completions/completions/starship
	rm -f $TERMUX_PREFIX/share/fish/vendor_completions.d/starship.fish
	rm -f $TERMUX_PREFIX/share/zsh/site-functions/_starship
	EOF
}
