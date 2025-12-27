TERMUX_PKG_HOMEPAGE=https://github.com/zeronet-conservancy/zeronet-conservancy
TERMUX_PKG_DESCRIPTION="Decentralized websites using Bitcoin crypto and BitTorrent network - modern client"
# project underwent disorganized license change before being abandoned
# fork requires GPL-3.0-or-later for all new contributions,
# and licensing status of old portions of code is unknown
# https://github.com/zeronet-conservancy/zeronet-conservancy/issues/113
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=75a4aff9aed66d351f694366ff052abeb999e988
_COMMIT_DATE=20251222
TERMUX_PKG_VERSION="0.7.10-p$_COMMIT_DATE"
TERMUX_PKG_SRCURL=git+https://github.com/zeronet-conservancy/zeronet-conservancy
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_SHA256=1580d7e27659b7b8a10222df7dcff5a10d5503fe6081d051fd48fa89ab4e4773
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_CONFFILES="etc/zeronet.conf"
TERMUX_PKG_DEPENDS="bash, clang, make, openssl-tool, pkg-config, python, python-pip"
TERMUX_PKG_PROVIDES="zeronet"
TERMUX_PKG_CONFLICTS="zeronet"
TERMUX_PKG_REPLACES="zeronet"
TERMUX_PKG_RECOMMENDS="tor"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout "$_COMMIT"

	local pdate="p$(git log -1 --format=%cs | sed 's/-//g')"
	if [[ "$TERMUX_PKG_VERSION" != *"${pdate}" ]]; then
		echo -n "ERROR: The version string \"$TERMUX_PKG_VERSION\" is"
		echo -n " different from what is expected to be; should end"
		echo " with \"${pdate}\"."
		return 1
	fi

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
	fi
}

termux_step_pre_configure() {
	# assist with downstream patch methods that bulk-replace
	# string 'com.termux' throughout the repository
	local original_prefix_component_one="/data/data/com."
	local original_prefix_component_two="termux/files/usr"
	local original_prefix="${original_prefix_component_one}${original_prefix_component_two}"
	if [[ "$TERMUX_PREFIX" != "$original_prefix" ]]; then
		echo "Replacing '$original_prefix' with '$TERMUX_PREFIX' in 'src/Crypt/CryptConnection.py'"
		sed -i -e "s|$original_prefix|$TERMUX_PREFIX|g" "$TERMUX_PKG_SRCDIR/src/Crypt/CryptConnection.py"
	fi
}

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
