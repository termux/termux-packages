TERMUX_PKG_HOMEPAGE=http://www.html-tidy.org/
TERMUX_PKG_DESCRIPTION="A tool to tidy down your HTML code to a clean style"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="README/LICENSE.md"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.8.0
TERMUX_PKG_SRCURL=https://github.com/htacg/tidy-html5/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2fc78c4369cde9a80f4ae3961880bd003ac31e8b160f6b9422645bab3be5a6cf
TERMUX_PKG_DEPENDS="libxslt"
TERMUX_PKG_BREAKS="tidy-dev"
TERMUX_PKG_REPLACES="tidy-dev"
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
