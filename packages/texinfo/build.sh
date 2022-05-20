TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/texinfo/
TERMUX_PKG_DESCRIPTION="Documentation system for on-line information and printed output"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.8
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/texinfo/texinfo-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8eb753ed28bca21f8f56c1a180362aed789229bd62fff58bf8368e9beb59fec4
# gawk is used by texindex:
TERMUX_PKG_DEPENDS="libiconv, ncurses, perl, gawk"
TERMUX_PKG_RECOMMENDS="update-info-dir"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-perl-xs"
TERMUX_PKG_GROUPS="base-devel"

termux_step_post_get_source() {
	local patch_url="https://src.fedoraproject.org/rpms/texinfo/raw/9b2cca4817fa4bd8d520fed05e9560fc7183dcdf/f/texinfo-6.8-undo-gnulib-nonnul.patch"
	local patch_filename="$(basename $patch_url)"
	termux_download \
		"$patch_url" \
		$TERMUX_PKG_CACHEDIR/"$patch_filename" \
		990f9db4d2b0887a92f22ff513ec3a28c7effd63fb7ef93bfb5a7332d295ed4b
	cat $TERMUX_PKG_CACHEDIR/"$patch_filename" | patch --silent -p1
}
