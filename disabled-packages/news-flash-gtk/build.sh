TERMUX_PKG_HOMEPAGE=https://github.com/patchedsoul/news-flash
TERMUX_PKG_DESCRIPTION="A modern feed reader designed for the GNOME desktop"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.2
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/patchedsoul/news-flash/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bc4ce6aa7cd26409d5d9a7ffa539214c9907c7b263eb88f46d8bbab7546fd323
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo, libhandy-0.0, libsqlite, libxml2, openssl-1.1, pango, webkit2gtk-4.1"
TERMUX_PKG_BUILD_DEPENDS="libsoup"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CPPFLAGS="-I$TERMUX_PREFIX/include/openssl-1.1 $CPPFLAGS"
	local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
	export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=-Wl,-rpath=$TERMUX_PREFIX/lib/openssl-1.1"

	TERMUX_RUST_VERSION=1.52.1
	termux_setup_rust
	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	rm -rf $CARGO_HOME/registry/src/*/webkit2gtk-sys-*
	cargo fetch --target $CARGO_TARGET_NAME

	local p=$TERMUX_PKG_BUILDER_DIR/webkit2gtk-sys.diff
	local d
	for d in $CARGO_HOME/registry/src/*/webkit2gtk-sys-*; do
		echo "Applying $(basename ${p}) to $(basename ${d})"
		patch --silent -p1 -d ${d} < ${p} || :
	done

	export RUSTC_BOOTSTRAP=1
	export GETTEXT_DIR=$TERMUX_PREFIX

	local wrapper_bin=$TERMUX_PKG_BUILDDIR/_wrapper/bin
	local wrapper_tmp=$TERMUX_PKG_BUILDDIR/_wrapper/tmp
	rm -rf $wrapper_bin $wrapper_tmp
	mkdir -p $wrapper_bin $wrapper_tmp
	cat <<-EOF > $wrapper_bin/cc
		#!$(command -v sh)
		exec $(command -v cc) -L/usr/lib/x86_64-linux-gnu "\$@"
	EOF
	chmod 0700 $wrapper_bin/cc
	export PATH="$wrapper_bin:$PATH"

	local _CARGO_TARGET_LIBDIR=target/$CARGO_TARGET_NAME/release/deps
	mkdir -p $_CARGO_TARGET_LIBDIR
	echo "char *gettext(const char *msgid){return (char *)msgid;}" | \
		$CC $CPPFLAGS -fPIC -x c -c - -o $wrapper_tmp/gettext.o
	local libintl_a=$_CARGO_TARGET_LIBDIR/libintl.a
	rm -rf $libintl_a
	$AR cru $libintl_a $wrapper_tmp/gettext.o
	local lib
	for lib in crypto ssl; do
		ln -s $TERMUX_PREFIX/lib/openssl-1.1/lib${lib}.so \
			$_CARGO_TARGET_LIBDIR/
	done
}

termux_step_configure() {
	sed src/config.rs.in \
		-e 's|@APP_ID@|"com.gitlab.newsflash"|g' \
		-e 's|@VERSION@|"'"$TERMUX_PKG_VERSION"'"|g' \
		-e 's|@PROFILE@|""|g' \
		> src/config.rs
}

termux_step_make() {
	cargo build \
		--jobs $TERMUX_PKG_MAKE_PROCESSES \
		--target $CARGO_TARGET_NAME \
		--release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin \
		target/${CARGO_TARGET_NAME}/release/news_flash_gtk
}

termux_step_post_massage() {
	rm -rf $CARGO_HOME/registry/src/*/webkit2gtk-sys-*
}
