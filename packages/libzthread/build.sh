TERMUX_PKG_HOMEPAGE=http://zthread.sourceforge.net/
TERMUX_PKG_DESCRIPTION="An advanced object-oriented, cross-platform, C++ threading and synchronization library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/zthread/ZThread-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=950908b7473ac10abb046bd1d75acb5934344e302db38c2225b7a90bd1eda854
TERMUX_PKG_DEPENDS="libc++"

termux_step_post_get_source() {
	termux_download \
		"https://github.com/gentoo/gentoo/raw/ae61075e7fb307c5f13810963099df88f99df426/dev-libs/zthread/files/zthread-2.3.2-no-fpermissive-r1.diff" \
		$TERMUX_PKG_CACHEDIR/zthread-2.3.2-no-fpermissive-r1.diff \
		ac0acd39a1122887c7d62efd078b9649a8f010ce48305c1d225fc81b8452a511
	cat $TERMUX_PKG_CACHEDIR/zthread-2.3.2-no-fpermissive-r1.diff | patch --silent -p1
}

termux_step_pre_configure() {
	autoreconf -fi -Ishare

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
