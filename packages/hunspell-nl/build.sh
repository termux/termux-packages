TERMUX_PKG_HOMEPAGE=https://www.opentaal.org/
TERMUX_PKG_DESCRIPTION="Dutch dictionary for hunspell"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.20.23
TERMUX_PKG_SRCURL=( https://raw.githubusercontent.com/OpenTaal/opentaal-hunspell/1c22bc3d61b2/{README.md,LICENSE.txt,nl.aff,nl.dic} )
TERMUX_PKG_SHA256=(
	cfaa817c61cc459bcae5fa52395b096bdf08a48419e9bf5e47d077deadb43543
	fd9e95c360245eab3c388885062820754785faa4123964994cfdecb950b71948
	b4d6263eb73c46c47759b0f605e324e48d157bdbd57a8f6bf2b2d051549d9966
	f1bcc9f6c3c71709d7e29463f1c45c50c26c7c3b172808545e3596bac8a75331
)
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_extract_src_archive() {
	mkdir -p "$TERMUX_PKG_SRCDIR"
	cp "$TERMUX_PKG_CACHEDIR/LICENSE.txt" "$TERMUX_PKG_SRCDIR"
}

termux_step_make() {
	:
}

termux_step_make_install() {
	install -Dm644 "$TERMUX_PKG_CACHEDIR/nl.aff" "$TERMUX_PREFIX/share/hunspell/nl_NL.aff"
	install -Dm644 "$TERMUX_PKG_CACHEDIR/nl.dic" "$TERMUX_PREFIX/share/hunspell/nl_NL.dic"
	install -Dm600 -t "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME" "$TERMUX_PKG_CACHEDIR/README.md"
}
