TERMUX_PKG_HOMEPAGE=https://www.tug.org/texlive/
TERMUX_PKG_DESCRIPTION="Wrapper around texlive's install-tl script"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=20210325
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=ftp://ftp.tug.org/texlive/historic/${TERMUX_PKG_VERSION:0:4}/install-tl-unx.tar.gz
TERMUX_PKG_SHA256=74eac0855e1e40c8db4f28b24ef354bd7263c1f76031bdc02b52156b572b7a1d
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_DEPENDS="perl, texlive-bin (>= 20200406-4), gnupg, curl, lz4, xz-utils"
TERMUX_PKG_REPLACES="texlive"
TERMUX_PKG_BREAKS="texlive"
TERMUX_PKG_RM_AFTER_INSTALL="opt/texlive/install-tl/texmf-dist"

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/opt/texlive
	sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		-e "s|@INSTALLER_VERSION@|${TERMUX_PKG_VERSION}|g" \
		"$TERMUX_PKG_BUILDER_DIR"/installer.sh \
		> $TERMUX_PREFIX/bin/termux-install-tl
	chmod 700 $TERMUX_PREFIX/bin/termux-install-tl

	sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		"$TERMUX_PKG_BUILDER_DIR"/termux-patch-texlive.sh \
		> $TERMUX_PREFIX/bin/termux-patch-texlive
	chmod 700 $TERMUX_PREFIX/bin/termux-patch-texlive

	sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		-e "s|@YEAR@|${TERMUX_PKG_VERSION:0:4}|g" \
		"$TERMUX_PKG_BUILDER_DIR"/termux.profile \
		> $TERMUX_PREFIX/opt/texlive/termux.profile
	chmod 600 $TERMUX_PREFIX/opt/texlive/termux.profile

	for DIFF in "$TERMUX_PKG_BUILDER_DIR"/*.diff; do
		sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" $DIFF \
			> $TERMUX_PREFIX/opt/texlive/$(basename $DIFF)
		chmod 600 $TERMUX_PREFIX/opt/texlive/$(basename $DIFF)
	done

	if [ -d "$TERMUX_PREFIX/opt/texlive/install-tl" ]; then
		rm -r "$TERMUX_PREFIX/opt/texlive/install-tl"
	fi
	cp -r $TERMUX_PKG_SRCDIR/ $TERMUX_PREFIX/opt/texlive/install-tl

	mkdir -p $TERMUX_PREFIX/etc/profile.d/
	echo "export PATH=\$PATH:$TERMUX_PREFIX/bin/texlive" \
		> $TERMUX_PREFIX/etc/profile.d/texlive.sh
}

termux_step_create_debscripts() {
	{
		echo "#!$TERMUX_PREFIX/bin/sh"
		echo "echo ''"
		echo "echo '[*] You can now run the texlive installer by running'"
		echo "echo ''"
		echo "echo '      termux-install-tl'"
		echo "echo ''"
		echo "echo '    It forwards extra arguments to the install-tl script.'"
	} > ./postinst
}
