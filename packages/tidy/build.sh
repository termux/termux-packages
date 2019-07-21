TERMUX_PKG_HOMEPAGE=http://www.html-tidy.org/
TERMUX_PKG_DESCRIPTION="A tool to tidy down your HTML code to a clean style"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=5.7.28
TERMUX_PKG_SRCURL=https://github.com/htacg/tidy-html5/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5caa2c769204f506e24ea4986a45abe23f71d14f0fe968314f20065f342ffdba
TERMUX_PKG_DEPENDS="libxslt"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	## Host build required to generate man pages.
	termux_setup_cmake
	cmake "$TERMUX_PKG_SRCDIR" && make
}

termux_step_post_make_install() {
	install -Dm600 \
		"$TERMUX_PKG_HOSTBUILD_DIR"/tidy.1 \
		"$TERMUX_PREFIX"/share/man/man1/
}
