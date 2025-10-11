TERMUX_PKG_HOMEPAGE=https://github.com/zeronet-conservancy/zeronet-conservancy
TERMUX_PKG_DESCRIPTION="Decentralized websites using Bitcoin crypto and BitTorrent network - modern client"
# project underwent disorganized license change before being abandoned
# fork requires GPL-3.0-or-later for all new contributions,
# and licensing status of old portions of code is unknown
# https://github.com/zeronet-conservancy/zeronet-conservancy/issues/113
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.7.10"
TERMUX_PKG_SRCURL="https://github.com/zeronet-conservancy/zeronet-conservancy/archive/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=ee5176744ccfef15c5f850982aefb763006815a078a9d1a9414e74a991901fea
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_CONFFILES="etc/zeronet.conf"
TERMUX_PKG_DEPENDS="bash, clang, make, openssl-tool, pkg-config, python"
TERMUX_PKG_PROVIDES="zeronet"
TERMUX_PKG_CONFLICTS="zeronet"
TERMUX_PKG_REPLACES="zeronet"
TERMUX_PKG_RECOMMENDS="tor"

termux_step_make_install() {
	# ZeroNet sources.
	mkdir -p "$TERMUX_PREFIX"/opt
	rm -rf "$TERMUX_PREFIX"/opt/zeronet
	cp -a "$TERMUX_PKG_SRCDIR" "$TERMUX_PREFIX"/opt/zeronet

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
		echo "LDFLAGS=-lpython$TERMUX_PYTHON_VERSION pip3 install -r $TERMUX_PREFIX/opt/zeronet/requirements.txt"
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
