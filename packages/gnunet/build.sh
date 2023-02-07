TERMUX_PKG_HOMEPAGE=https://gnunet.org
TERMUX_PKG_DESCRIPTION="A framework for secure peer-to-peer networking"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_SRCURL=git+https://git.gnunet.org/git/gnunet
TERMUX_PKG_VERSION=0.19.3
TERMUX_PKG_SHA256=ccd94f78acee510355b3e17bdb6d75c691d8ed049a2208facc6fe91757fcfd86
TERMUX_PKG_DEPENDS="libcurl, libgcrypt, libgnutls, libgpg-error, libidn2, libjansson, libltdl, libmicrohttpd, libsodium, libsqlite, libunistring, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_have_decl_struct_in6_ifreq=yes"

# `termux_step_get_source` does not work by default:
#
# ```
# Submodule 'contrib/gana' (git://git.gnunet.org/gana.git) registered for path 'contrib/gana'
# Submodule 'doc/sphinx' (https://git.gnunet.org/gnunet-handbook) registered for path 'contrib/sphinx'
# Cloning into '/home/builder/.termux-build/gnunet/cache/tmp-checkout/contrib/gana'...
# Cloning into '/home/builder/.termux-build/gnunet/cache/tmp-checkout/contrib/sphinx'...
# From git://git.gnunet.org/gana
#  * branch            79163ab6ea6f6cfe7f4311f91fb45c747b8c33da -> FETCH_HEAD
# Submodule path 'contrib/gana': checked out '79163ab6ea6f6cfe7f4311f91fb45c747b8c33da'
# error: Server does not allow request for unadvertised object 4f40b5deca02c8dc64ff6c73e6602e6abdd1bae2
# fatal: Fetched in submodule path 'contrib/sphinx', but it did not contain 4f40b5deca02c8dc64ff6c73e6602e6abdd1bae2. Direct fetching of that commit failed.
# fatal: 
# ##[error]Process completed with exit code 128.
# ```
termux_step_get_source() {
	rm -rf $TERMUX_PKG_SRCDIR
	mkdir -p $TERMUX_PKG_SRCDIR
	cd $TERMUX_PKG_SRCDIR
	git clone --depth 1 --branch v${TERMUX_PKG_VERSION} \
		${TERMUX_PKG_SRCURL#git+} .
	git submodule update --init --recursive
}

termux_step_post_get_source() {
	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
	fi
}

termux_step_pre_configure() {
	CPPFLAGS+=" -D_LINUX_IN6_H"
	./bootstrap
}
