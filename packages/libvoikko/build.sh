TERMUX_PKG_HOMEPAGE="http://voikko.sourceforge.net"
TERMUX_PKG_DESCRIPTION="A spelling and grammar checker, hyphenator and collection of related linguistic data for Finnish language"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.3.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.puimula.org/voikko-sources/libvoikko/libvoikko-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0156c2aaaa32d4b828addc7cefecfcea4591828a0b40f0cd8a80cd22f8590da2
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-hfst=false
"

termux_step_pre_configure() {
	# ld.lld: error: non-exported symbol '__aeabi_uidiv' in '/home/builder/.termux-build/_cache/android-r27b-api-24-v1/lib/clang/18/lib/linux/libclang_rt.builtins-arm-android.a(udivsi3.S.o)' is referenced by DSO '../.libs/libvoikko.so'
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
