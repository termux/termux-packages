TERMUX_PKG_HOMEPAGE=http://www.brow.sh/
TERMUX_PKG_DESCRIPTION="A fully-modern text-based browser, rendering to TTY and browsers"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux-user-repository"
TERMUX_PKG_VERSION=1.8.3
TERMUX_PKG_SRCURL=(
	"https://github.com/browsh-org/browsh/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
	"https://github.com/browsh-org/browsh/releases/download/v$TERMUX_PKG_VERSION/browsh-$TERMUX_PKG_VERSION.xpi"
)
TERMUX_PKG_SHA256=(
	88462530dbfac4e17c8f8ba560802d21042d90236043e11461a1cfbf458380ca
	c0b72d7c61c30a0cb79cc1bf9dcf3cdaa3631ce029f1578e65c116243ed04e16
)
TERMUX_PKG_DEPENDS="firefox"
TERMUX_PKG_ANTI_BUILD_DEPENDS="firefox"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"

termux_extract_src_archive() {
	# The default version of the tarball extraction function chokes on the .xpi file
	local tarball extension
	tarball="$TERMUX_PKG_CACHEDIR/$(basename "${TERMUX_PKG_SRCURL[0]}")"
	mkdir -p "$TERMUX_PKG_SRCDIR"
	tar -xf "$tarball" -C "$TERMUX_PKG_SRCDIR" --strip-components=1

	extension="$TERMUX_PKG_CACHEDIR/$(basename "${TERMUX_PKG_SRCURL[1]}")"
	cp -f "$extension" "$TERMUX_PKG_SRCDIR/interfacer/src/browsh/browsh.xpi"
}

termux_step_pre_configure() {
	termux_setup_golang
}

termux_step_make() {
	cd "$TERMUX_PKG_SRCDIR/interfacer" && \
	go build -x -modcacherw -o ./bin/browsh ./cmd/browsh
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" ./interfacer/bin/browsh
}
