TERMUX_PKG_HOMEPAGE="http://voikko.sourceforge.net"
TERMUX_PKG_DESCRIPTION="A spelling and grammar checker, hyphenator and collection of related linguistic data for Finnish language"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.3.3"
TERMUX_PKG_SRCURL=https://www.puimula.org/voikko-sources/libvoikko/libvoikko-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d1162965c61de44f72162fd87ec1394bd4f90f87bc8152d13fe4ae692fdc73fa
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-hfst=false
"

termux_step_pre_configure() {
	# ld.lld: error: non-exported symbol '__aeabi_uidiv' in '/home/builder/.termux-build/_cache/android-r27b-api-24-v1/lib/clang/18/lib/linux/libclang_rt.builtins-arm-android.a(udivsi3.S.o)' is referenced by DSO '../.libs/libvoikko.so'
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
