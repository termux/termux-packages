TERMUX_PKG_HOMEPAGE=https://github.com/emacs-exwm/exwm
TERMUX_PKG_DESCRIPTION="Emacs X Window Manager"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.34"
TERMUX_PKG_SRCURL="https://github.com/emacs-exwm/exwm/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=ebe730bbda5bce75baf4532173171a9283a58684e7ec84192ba03c3d8328cf0a
TERMUX_PKG_DEPENDS="emacs-x, emacs-xelb"
TERMUX_PKG_RECOMMENDS="dbus"
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
	emacs -Q -batch \
		-L . -L "$TERMUX_PREFIX/share/emacs/site-lisp/xelb" \
		-f batch-byte-compile *.el
}

termux_step_make_install() {
	local file
	for file in *.el; do
		install -Dm644 "$file" "$TERMUX_PREFIX/share/emacs/site-lisp/exwm/$file"
	done
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	echo "How to use EXWM:"
	echo "1. remove any preexisting manual installations of EXWM or XELB:"
	echo "  $ rm -rf ~/.emacs.d/elpa/{xelb,exwm}*"
	echo "2. put this content in '~/.emacs':"
	echo "  (require 'exwm)"
	echo "  (exwm-wm-mode)"
	echo
	echo "  In-depth configuration examples are available in the official documentation: https://github.com/emacs-exwm/exwm/wiki#bootstrap"
	echo "3. launch the X11 server with emacs as the window manager:"
	echo "  $ termux-x11 -xstartup \"dbus-launch --exit-with-session emacs\""
	EOF
	chmod +x ./postinst
}
