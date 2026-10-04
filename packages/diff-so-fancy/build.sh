TERMUX_PKG_HOMEPAGE="https://github.com/so-fancy/diff-so-fancy"
TERMUX_PKG_DESCRIPTION="Good-lookin' diffs. Actually... nah... The best-lookin' diffs"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION="1.4.14"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_SRCURL="https://github.com/so-fancy/diff-so-fancy/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=7ebdaaac4aade23a9b5296f560484e42a864331903febe92314b530380a34734
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_RECOMMENDS="git"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	# relative paths of vendored libs to absolute system lib paths
	sed "s#^use lib .*\$#use lib \"$TERMUX_PREFIX/share/diff-so-fancy\";#" -i diff-so-fancy

	install -Dm700 diff-so-fancy        "$TERMUX_PREFIX/bin/diff-so-fancy"
	install -Dm700 lib/DiffHighlight.pm "$TERMUX_PREFIX/share/diff-so-fancy/DiffHighlight.pm"
	install -Dm600 README.md            "$TERMUX_PREFIX/share/doc/diff-so-fancy/README.md"
}
