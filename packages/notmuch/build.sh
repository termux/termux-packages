TERMUX_PKG_HOMEPAGE=https://notmuchmail.org
TERMUX_PKG_DESCRIPTION="Thread-based email index, search and tagging system"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.40"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://notmuchmail.org/releases/notmuch-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=4b4314bbf1c2029fdf793637e6c7bb15c1b1730d22be9aa04803c98c5bbc446f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, libc++, libgmime, libtalloc, libxapian, zlib"
TERMUX_PKG_BUILD_DEPENDS="emacs"
TERMUX_PKG_RECOMMENDS="emacs"
TERMUX_PKG_BREAKS="notmuch-dev"
TERMUX_PKG_REPLACES="notmuch-dev"
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

	termux_download_ubuntu_packages install-info
}

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		export PATH="${TERMUX_PKG_HOSTBUILD_DIR}/EMACS/bin:${PATH}"
		export PATH="${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages/usr/bin:${PATH}"
	fi
}

termux_step_configure() {
	# Use python3 so that the python3-sphinx package is
	# found for man page generation.
	export PYTHON=python3

	cd $TERMUX_PKG_SRCDIR
	XAPIAN_CONFIG=$TERMUX_PREFIX/bin/xapian-config ./configure \
		--prefix=$TERMUX_PREFIX \
		--without-api-docs \
		--without-desktop \
		--with-emacs \
		--emacslispdir="$TERMUX_PREFIX/share/emacs/site-lisp/notmuch" \
		--emacsetcdir="$TERMUX_PREFIX/share/emacs/site-lisp/notmuch" \
		--without-ruby
}
