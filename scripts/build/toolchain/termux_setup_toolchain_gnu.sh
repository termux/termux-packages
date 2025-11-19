termux_setup_toolchain_gnu() {
	export CFLAGS="-O2 -pipe -fno-plt -fexceptions -Wp,-D_FORTIFY_SOURCE=2 -Wformat -Werror=format-security -fstack-clash-protection"
	export CPPFLAGS=""
	export LDFLAGS=""

	export CC=$TERMUX_HOST_PLATFORM-gcc
	export CXX=$TERMUX_HOST_PLATFORM-g++
	export AR=$TERMUX_HOST_PLATFORM-gcc-ar
	export RANLIB=$TERMUX_HOST_PLATFORM-gcc-ranlib
	export NM=$TERMUX_HOST_PLATFORM-gcc-nm
	export LD=ld
	export AS=as
	export OBJCOPY=objcopy
	export OBJDUMP=objdump
	export READELF=readelf
	export STRIP=strip
	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		export CXXFILT=c++filt
	else
		export CXXFILT=$TERMUX_HOST_PLATFORM-c++filt
	fi

	if [ ! -d "$TERMUX__PREFIX__LIB_DIR/" ]; then
		termux_error_exit "glibc library directory was not found ('$TERMUX__PREFIX__LIB_DIR/')"
	fi
	if [ ! -f "$TERMUX__PREFIX__LIB_DIR/libgcc_s.so" ] && [ ! -f "$TERMUX__PREFIX__LIB_DIR/libgcc_s.so.1" ]; then
		termux_error_exit "libgcc not found, there is a risk of incorrect compiler operation"
	fi
	if [ ! -d "$TERMUX__PREFIX__BASE_INCLUDE_DIR/" ]; then
		termux_error_exit "glibc base header directory was not found ('$TERMUX__PREFIX__BASE_INCLUDE_DIR/')"
	fi
	if [ "$TERMUX_ARCH" != "$TERMUX_REAL_ARCH" ] && [ ! -d "$TERMUX__PREFIX__MULTI_INCLUDE_DIR/" ]; then
		termux_error_exit "glibc multi header directory was not found ('$TERMUX__PREFIX__MULTI_INCLUDE_DIR/')"
	fi

	if [ "$TERMUX_ARCH" = "aarch64" ]; then
		CFLAGS+=" -march=armv8-a"
		export DYNAMIC_LINKER="ld-linux-aarch64.so.1"
	elif [ "$TERMUX_ARCH" = "arm" ]; then
		CFLAGS+=" -march=armv7-a -mfloat-abi=hard -mfpu=neon"
		export DYNAMIC_LINKER="ld-linux-armhf.so.3"
	elif [ "$TERMUX_ARCH" = "x86_64" ]; then
		CFLAGS+=" -march=x86-64 -fPIC"
		export DYNAMIC_LINKER="ld-linux-x86-64.so.2"
	elif [ "$TERMUX_ARCH" = "i686" ]; then
		CFLAGS+=" -march=i686"
		export DYNAMIC_LINKER="ld-linux.so.2"
	fi
	export PATH_DYNAMIC_LINKER="$TERMUX__PREFIX__BASE_LIB_DIR/$DYNAMIC_LINKER"

	if [ ! -f "$PATH_DYNAMIC_LINKER" ]; then
		termux_error_exit "glibc dynamic linker was not found ('$PATH_DYNAMIC_LINKER')"
	fi

	case "$TERMUX_ARCH" in
		"aarch64"|"arm") CFLAGS+=" -fstack-protector-strong";;
		"x86_64"|"i686") CFLAGS+=" -mtune=generic -fcf-protection";;
	esac

	case "$TERMUX_ARCH" in
		"aarch64") export LINUX_ARCH="arm64";;
		"arm") export LINUX_ARCH="arm";;
		"x86_64"|"i686") export LINUX_ARCH="x86";;
	esac

 	export CCTERMUX_HOST_PLATFORM=$TERMUX_HOST_PLATFORM

	export PKG_CONFIG=pkg-config
	export PKGCONFIG=$PKG_CONFIG
 	export PKG_CONFIG_LIBDIR="$TERMUX_PKG_CONFIG_LIBDIR"

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		local BASE_PATH="$TERMUX_COMMON_CACHEDIR/BASE_PATH"
		if [ ! -d "$BASE_PATH" ]; then
			# Create BASE_PATH with basic commands taken from the system, so as
			# not to use commands from Termux (the application) during compilation.
			mkdir "$BASE_PATH"
			for com in [ b2sum base32 base64 basename basenc cat chcon chgrp chmod chown cksum comm cp csplit cut date dd dir dircolors \
				dirname du echo env expand expr factor false fmt fold groups head id install join kill link ln logname ls md5sum mkdir \
				mkfifo mknod mktemp mv nice nl nohup nproc numfmt od paste pathchk pr printenv printf ptx pwd readlink realpath rm rmdir \
				runcon seq sha1sum sha224sum sha256sum sha384sum sha512sum shred shuf sleep sort split stat stdbuf stty sum sync tac tail \
				tee test timeout touch tr true truncate tsort tty unexpand uniq unlink vdir wc whoami yes grep awk jq curl wget git; do
				ln -sf "/usr/bin/$com" "$BASE_PATH"
			done
		fi
		if ! tr ':' '\n' <<< "$PATH" | grep -q "^$TERMUX_PREFIX/bin$"; then
			export PATH="$TERMUX_PREFIX/bin:$PATH"
		fi
		if ! tr ':' '\n' <<< "$PATH" | grep -q "^$BASE_PATH$"; then
			export PATH="$BASE_PATH:$PATH"
		fi
	fi
	if ! tr ':' '\n' <<< "$PATH" | grep -q "^$TERMUX_STANDALONE_TOOLCHAIN/bin$"; then
		export PATH="$TERMUX_STANDALONE_TOOLCHAIN/bin:$PATH"
	fi

	export CXXFLAGS="$CFLAGS -Wp,-D_GLIBCXX_ASSERTIONS"
}
