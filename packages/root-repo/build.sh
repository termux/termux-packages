TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-packages
TERMUX_PKG_DESCRIPTION="Package repository containing programs for rooted devices"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=2.5
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="termux-keyring"
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	mkdir -p "$TERMUX_PREFIX/etc/apt/sources.list.d"
	{ # write deb822 source entries for the root repo
	printf '%s\n' \
		"# The termux root repository, with cloudflare cache" \
		"Types: deb" \
		"URIs: https://packages-cf.termux.dev/apt/termux-root/" \
		"Suites: root" \
		"Components: stable" \
		"Signed-By: $TERMUX_PREFIX/etc/apt/trusted.gpg.d/grimler.gpg, $TERMUX_PREFIX/etc/apt/trusted.gpg.d/termux-autobuilds.gpg" \
		"" \
		"# The termux root repository, without cloudflare cache" \
		"#Types: deb" \
		"#URIs: https://packages.termux.dev/apt/termux-root/" \
		"#Suites: root" \
		"#Components: stable" \
		"#Signed-By: $TERMUX_PREFIX/etc/apt/trusted.gpg.d/grimler.gpg, $TERMUX_PREFIX/etc/apt/trusted.gpg.d/termux-autobuilds.gpg"
	} > "$TERMUX_PREFIX/etc/apt/sources.list.d/root.sources"
}

termux_step_create_debscripts() {
	[[ "$TERMUX_PACKAGE_FORMAT" == 'pacman' ]] && return 0

	local REPO="root"
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
