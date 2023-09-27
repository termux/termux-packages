TERMUX_PKG_HOMEPAGE=https://zeronet.io/
TERMUX_PKG_DESCRIPTION="Decentralized websites using Bitcoin crypto and BitTorrent network"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.7.1
TERMUX_PKG_REVISION=8
TERMUX_PKG_SRCURL=https://github.com/HelloZeroNet/ZeroNet/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=78a27e1687d8e3699a854b77b516c95b30a8ba667f7ebbef0aabf7ec6ec7272d
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_CONFFILES="etc/zeronet.conf"
TERMUX_PKG_DEPENDS="bash, clang, make, openssl-tool, pkg-config, python"
TERMUX_PKG_RECOMMENDS="tor"

termux_step_make_install() {
	# ZeroNet sources.
	mkdir -p "$TERMUX_PREFIX"/opt
	rm -rf "$TERMUX_PREFIX"/opt/zeronet
	cp -a "$TERMUX_PKG_SRCDIR" "$TERMUX_PREFIX"/opt/zeronet

	# Installer.
	install -Dm700 "$TERMUX_PKG_BUILDER_DIR"/installer.sh \
		"$TERMUX_PREFIX"/opt/zeronet/installer.sh
	sed -i "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
		"$TERMUX_PREFIX"/opt/zeronet/installer.sh

	# Wrapper.
	install -Dm700 "$TERMUX_PKG_BUILDER_DIR"/zeronet.sh \
		"$TERMUX_PREFIX"/bin/zeronet
	sed -i "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" \
		"$TERMUX_PREFIX"/bin/zeronet

	# Configuration file.
	install -Dm600 "$TERMUX_PKG_BUILDER_DIR"/zeronet.conf \
		"$TERMUX_PREFIX"/etc/zeronet.conf
}

termux_step_post_massage() {
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/var/lib/zeronet
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"/var/log/zeronet
}

termux_step_create_debscripts() {
	{
		echo "#!$TERMUX_PREFIX/bin/sh"
		echo "bash $TERMUX_PREFIX/opt/zeronet/installer.sh"
	} > ./postinst
	chmod 755 ./postinst

	{
		echo "#!$TERMUX_PREFIX/bin/sh"
		echo "[ \$1 != remove ] && exit 0"
		echo "echo \"Removing ZeroNet files...\""
		echo "rm -rf $TERMUX_PREFIX/opt/zeronet"
		echo "rm -rf $TERMUX_PREFIX/var/lib/zeronet"
		echo "rm -rf $TERMUX_PREFIX/var/log/zeronet"
		echo "exit 0"
	} > ./postrm
	chmod 755 ./postrm
}
