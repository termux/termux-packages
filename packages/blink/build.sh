TERMUX_PKG_HOMEPAGE=https://justine.lol/blinkenlights/
TERMUX_PKG_DESCRIPTION="Tiny x86-64 Linux emulator"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:1.1.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/jart/blink/archive/refs/tags/${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=2649793e1ebf12027f5e240a773f452434cefd9494744a858cd8bff8792dba68
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	# build system does not work with cross compilers
	# https://github.com/jart/blink/issues/111

	# enable all the ./configure compiler flags whenever possible
	export CFLAGS="${CFLAGS/-Oz/-O2}"
	export CPPFLAGS+=" -D_FILE_OFFSET_BITS=64"
	export CPPFLAGS+=" -D_DARWIN_C_SOURCE"
	export CPPFLAGS+=" -D_DEFAULT_SOURCE"
	export CPPFLAGS+=" -D_BSD_SOURCE"
	export CPPFLAGS+=" -D_GNU_SOURCE"
	export CPPFLAGS+=" -D_POSIX_C_SOURCE"
	export CPPFLAGS+=" -D_XOPEN_SOURCE"
	export LDFLAGS+=" -lm"
	export CFLAGS+=" -fpie"
	export LDFLAGS+=" -pie"
	#export LDFLAGS+=" -Wl,--image-base=0x23000000"
	#export LDFLAGS+=" -Wl,-z,max-page-size=65536"
	#export LDFLAGS+=" -Wl,-z,norelro"
	#export LDFLAGS+=" -Wl,-z,noseparate-code"
	export CFLAGS+=" -fno-common"
	export CFLAGS+=" -fno-sanitize=all"
	export CFLAGS+=" -fno-align-functions"
	export CFLAGS+=" -fno-stack-protector"
	export CFLAGS+=" -fno-omit-frame-pointer"
	export CFLAGS+=" -fno-optimize-sibling-calls"
	export CFLAGS+=" -fcf-protection=none"
}

termux_step_configure() {
	./configure --prefix="${TERMUX_PREFIX}"
}

termux_step_post_configure() {
	# https://github.com/jart/blink/blob/master/config.h.in
	# replace host generated config.h with our own
	# please check with a real device
	cp -f config.h.in config.h
	sed -e "s|^// #define HAVE_|#define HAVE_|g" -i config.h

	sed -e "s|^#define HAVE_SYSCTL|// #define HAVE_SYSCTL|" -i config.h

	if [[ "${TERMUX_ARCH_BITS}" == "32" ]]; then
		sed -e "s|^#define HAVE_INT128|// #define HAVE_INT128|" -i config.h
	fi

	sed -e "s|^#define HAVE_SA_LEN|// #define HAVE_SA_LEN|" -i config.h

	# TODO port libandroid-fexecve from Android P
	sed -e "s|^#define HAVE_FEXECVE|// #define HAVE_FEXECVE|" -i config.h

	# Bad System Call
	#sed -e "s|^#define HAVE_SETREUID|// #define HAVE_SETREUID|" -i config.h

	sed -e "s|^#define HAVE_KERN_ARND|// #define HAVE_KERN_ARND|" -i config.h

	# TODO port libandroid-random from Android P
	sed -e "s|^#define HAVE_GETRANDOM|// #define HAVE_GETRANDOM|" -i config.h

	# Bad System Call
	#sed -e "s|^#define HAVE_SETGROUPS|// #define HAVE_SETGROUPS|" -i config.h

	sed -e "s|^#define HAVE_LIBUNWIND|// #define HAVE_LIBUNWIND|" -i config.h

	# TODO port libandroid-random from Android P
	sed -e "s|^#define HAVE_GETENTROPY|// #define HAVE_GETENTROPY|" -i config.h

	sed -e "s|^#define HAVE_RTLGENRANDOM|// #define HAVE_RTLGENRANDOM|" -i config.h
	sed -e "s|^#define HAVE_LIBUNWIND|// #define HAVE_LIBUNWIND|" -i config.h
	sed -e "s|^#define HAVE_EPOLL_PWAIT2|// #define HAVE_EPOLL_PWAIT2|" -i config.h

	# TODO port libandroid-getsetdomainname from Android O
	sed -e "s|^#define HAVE_GETDOMAINNAME|// #define HAVE_GETDOMAINNAME|" -i config.h

	# Bad System Call
	#sed -e "s|^#define HAVE_CLOCK_SETTIME|// #define HAVE_CLOCK_SETTIME|" -i config.h

	sed -e "s|^#define HAVE_SYS_GETENTROPY|// #define HAVE_SYS_GETENTROPY|" -i config.h
	sed -e "s|^#define HAVE_PTHREAD_SETCANCELSTATE|// #define HAVE_PTHREAD_SETCANCELSTATE|" -i config.h
	sed -e "s|^#define HAVE_SOCKATMARK|// #define HAVE_SOCKATMARK|" -i config.h

	for f in config.log config.h config.mk; do
		echo "INFO: ========== ${f} =========="
		cat "${f}"
		echo "INFO: ========== ${f} =========="
	done
}
