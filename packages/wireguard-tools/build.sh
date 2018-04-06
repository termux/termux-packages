TERMUX_PKG_HOMEPAGE=https://www.wireguard.com
TERMUX_PKG_DESCRIPTION="Tools for the WireGuard secure network tunnel"
TERMUX_PKG_VERSION=0.0.20180304
wg_quick_commit=73431b5458ed352e49e6fefe85f075483035a1c9
TERMUX_PKG_SRCURL=("https://git.zx2c4.com/WireGuard/snapshot/WireGuard-$TERMUX_PKG_VERSION.tar.xz" "https://git.zx2c4.com/wireguard-android/plain/app/tools/wg-quick.c?id=$wg_quick_commit")
TERMUX_PKG_SHA256=("efb1652f0da67fb2731040439b6abb820a5e2f1bc177aa15c5dce68ea3327787" "cf1e2f2f7e710f018f05f97334832cb045862a25a004b6524a5d7c68d92cad6e")
TERMUX_PKG_DEPENDS="libmnl, tsu"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_EXTRA_MAKE_ARGS=" -C src/tools WITH_BASHCOMPLETION=yes WITH_WGQUICK=no WITH_SYSTEMDUNITS=no"

termux_step_extract_package() {
	# Download and extract WireGuard:
	if [ -z "${TERMUX_PKG_SRCURL:=""}" ]; then
		mkdir -p "$TERMUX_PKG_SRCDIR"
		return
	fi
	cd "$TERMUX_PKG_TMPDIR"
	local filename
	filename=$(basename "${TERMUX_PKG_SRCURL[0]}")
	local file="$TERMUX_PKG_CACHEDIR/$filename"
	termux_download "${TERMUX_PKG_SRCURL[0]}" "$file" "${TERMUX_PKG_SHA256[0]}"

	local folder
	set +o pipefail
	if [ "${file##*.}" = zip ]; then
		folder=`unzip -qql "$file" | head -n1 | tr -s ' ' | cut -d' ' -f5-`
		rm -Rf $folder
		unzip -q "$file"
	else
		folder=`tar tf "$file" | head -1 | sed 's/^.\///' | sed -e 's/\/.*//'`
		rm -Rf $folder
		tar xf "$file"
	fi
	set -o pipefail
	mv $folder "$TERMUX_PKG_SRCDIR"

	# Download wq-quick.c
	filename=$(basename "${TERMUX_PKG_SRCURL[1]}")
	local file="$TERMUX_PKG_CACHEDIR/wg-quick.c"
	termux_download "${TERMUX_PKG_SRCURL[1]}" "$file" "${TERMUX_PKG_SHA256[1]}"
	mkdir $TERMUX_PKG_SRCDIR/src/wg-quick
	mv $file $TERMUX_PKG_SRCDIR/src/wg-quick/
}

termux_step_post_make_install() {
	cd $TERMUX_PKG_SRCDIR/src/wg-quick
	make
	make install
}
