TERMUX_PKG_HOMEPAGE=https://github.com/emacs-exwm/xelb
TERMUX_PKG_DESCRIPTION="X protocol Emacs Lisp Binding"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.19"
TERMUX_PKG_SRCURL="https://github.com/emacs-exwm/xelb/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=b518d4b74f41eaa104d389f77d9fe90eb1b99031d6afd7ba5a9dfd5dd49af112
TERMUX_PKG_DEPENDS="emacs-x"
TERMUX_PKG_BUILD_DEPENDS="xcb-proto"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	EMACS_SRCURL=https://mirrors.kernel.org/gnu/emacs/emacs-30.2.tar.xz
	EMACS_SHA256=b3f36f18a6dd2715713370166257de2fae01f9d38cfe878ced9b1e6ded5befd9
	EMACS_ARCHIVE="${TERMUX_PKG_CACHEDIR}/EMACS.tar.xz"
	EMACS_WORKDIR="${TERMUX_PKG_TMPDIR}/EMACS"
	EMACS_INSTALLDIR="${TERMUX_PKG_HOSTBUILD_DIR}/EMACS"
	mkdir -p "${EMACS_WORKDIR}" "${EMACS_INSTALLDIR}"
	termux_download "$EMACS_SRCURL" "$EMACS_ARCHIVE" "$EMACS_SHA256"
	tar xf "${TERMUX_PKG_CACHEDIR}/EMACS.tar.xz" --strip-components=1 -C "${EMACS_WORKDIR}"
	pushd "${EMACS_WORKDIR}"
	./configure \
		--without-xpm \
		--without-gif \
		--without-gnutls \
		--prefix="${EMACS_INSTALLDIR}"
	make -j"$TERMUX_PKG_MAKE_PROCESSES"
	make install
	popd
}

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		export PATH="${TERMUX_PKG_HOSTBUILD_DIR}/EMACS/bin:${PATH}"
	fi
}

termux_step_make() {
	# does not work properly with -j "$TERMUX_PKG_MAKE_PROCESSES"
	make PROTO_PATH="$TERMUX_PREFIX/share/xcb"
	emacs -Q -batch -L . -f batch-byte-compile *.el
}

termux_step_make_install() {
	local file
	for file in *.el; do
		install -Dm644 "$file" "$TERMUX_PREFIX/share/emacs/site-lisp/xelb/$file"
	done
}
