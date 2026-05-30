TERMUX_PKG_HOMEPAGE=https://github.com/termux-user-repository/tur
TERMUX_PKG_DESCRIPTION="A single and trusted place for all unofficial/less popular termux packages"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux-user-repository"
TERMUX_PKG_VERSION=1.0.2
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	mkdir -p "$TERMUX_PREFIX/etc/apt/sources.list.d"
	{ # write deb822 source entries for the TUR repo
	printf '%s\n' \
		"# A single and trusted place for all unofficial/less popular termux packages" \
		"Types: deb" \
		"URIs: https://tur.kcubeterm.com/" \
		"Suites: tur-packages" \
		"Components: tur tur-on-device tur-continuous" \
		"Signed-By: $TERMUX_PREFIX/etc/apt/trusted.gpg.d/tur.gpg"
	} > "$TERMUX_PREFIX/etc/apt/sources.list.d/tur.sources"
	## tur gpg key
	install -Dm600 "$TERMUX_PKG_BUILDER_DIR/tur.gpg" "$TERMUX_PREFIX/etc/apt/trusted.gpg.d/"
}

termux_step_create_debscripts() {
	[[ "$TERMUX_PACKAGE_FORMAT" == 'pacman' ]] && return 0

	local REPO="tur"
	local LEGACY_SOURCES="sources.list.d/${REPO}.list"
	sed -e "s|@LEGACY_SOURCES@|${LEGACY_SOURCES}|g" \
		-e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		-e "s|@REPO@|${REPO}|g" \
		"$TERMUX_SCRIPTDIR/packages/apt/preinst.sh.in" > ./preinst

	sed -e "s|@LEGACY_SOURCES@|${LEGACY_SOURCES}|g" \
		-e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		-e "s|@REPO@|${REPO}|g" \
		"$TERMUX_SCRIPTDIR/packages/apt/postinst.sh.in" > ./postinst

	chmod +x ./preinst ./postinst
}
