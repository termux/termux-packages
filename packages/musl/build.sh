TERMUX_PKG_HOMEPAGE=https://musl.libc.org/
TERMUX_PKG_DESCRIPTION="Lightweight, fast, simple, and free C standard library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILES="COPYRIGHT"
TERMUX_PKG_MAINTAINER="@codingWiz-rick"
TERMUX_PKG_VERSION="1.2.5"
TERMUX_PKG_SRCURL=https://musl.libc.org/releases/musl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a9a118bbe84d8764da0ea0d28b3ab3fae8477fc7e4085d90102b8596fc7c75e4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

# Install to isolated location
MUSL_TOOLCHAIN_ROOT="$TERMUX_PREFIX/opt/musl-toolchain"
MUSL_SYSROOT="$MUSL_TOOLCHAIN_ROOT/sysroot"

TERMUX_PKG_DEPENDS="libandroid-complex-math"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--prefix=$MUSL_SYSROOT/usr
--syslibdir=$MUSL_SYSROOT/lib
--disable-gcc-wrapper
"

termux_step_pre_configure() {
	# Create sysroot structure
	mkdir -p "$MUSL_SYSROOT"/{lib,usr/{bin,lib,include},etc,tmp,var}
	mkdir -p "$MUSL_TOOLCHAIN_ROOT"/{bin,lib,share}
	
	CFLAGS="$CFLAGS -fno-lto"
	LDFLAGS="$LDFLAGS -rtlib=compiler-rt"
}

termux_step_configure() {
	./configure \
		--prefix="$MUSL_SYSROOT/usr" \
		--syslibdir="$MUSL_SYSROOT/lib" \
		--disable-gcc-wrapper \
		--enable-static \
		--enable-shared
}

termux_step_post_configure() {
	local CC_PATH=$(command -v $CC)
	local CLANG_DIR=$(dirname $(dirname $CC_PATH))
	local CLANG_VERSION=$(basename $(ls -d ${CLANG_DIR}/lib/clang/* 2>/dev/null | head -1))
	local BUILTINS="${CLANG_DIR}/lib/clang/${CLANG_VERSION}/lib/linux/libclang_rt.builtins-${TERMUX_ARCH}.a"
	
	if [ ! -f "$BUILTINS" ]; then
		BUILTINS=$(${CC} -print-libgcc-file-name 2>/dev/null || echo "")
		if [ -z "$BUILTINS" ] || [ ! -f "$BUILTINS" ]; then
			termux_error_exit "Cannot find compiler runtime library"
		fi
	fi
	
	echo "Using compiler runtime: $BUILTINS"
	
	# Patch config.mak which is what Makefile uses
	sed -i "s|^LIBCC = .*|LIBCC = ${BUILTINS} -lunwind|g" config.mak
	
	# Verify the change
	echo "LIBCC setting in config.mak:"
	grep "^LIBCC" config.mak
}

termux_step_make() {
	make -j $TERMUX_PKG_MAKE_PROCESSES
}

termux_step_make_install() {
	make install
	
	# Create symbolic links in sysroot
	cd "$MUSL_SYSROOT"
	ln -sfv lib lib64
	ln -sfv usr/lib usr/lib64
	
	# Create musl-clang wrapper in toolchain bin
	cat > "$MUSL_TOOLCHAIN_ROOT/bin/musl-clang" <<'EOF'
#!/bin/sh
MUSL_TOOLCHAIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MUSL_SYSROOT="$MUSL_TOOLCHAIN_ROOT/sysroot"

exec clang \
	--sysroot="$MUSL_SYSROOT" \
	-nostdinc \
	-isystem "$MUSL_SYSROOT/usr/include" \
	-L"$MUSL_SYSROOT/lib" \
	-L"$MUSL_SYSROOT/usr/lib" \
	-Wl,--dynamic-linker="$MUSL_SYSROOT/lib/ld-musl-$(uname -m).so" \
	-Wl,-rpath,"$MUSL_SYSROOT/lib" \
	-Wl,-rpath,"$MUSL_SYSROOT/usr/lib" \
	"$@"
EOF
	chmod +x "$MUSL_TOOLCHAIN_ROOT/bin/musl-clang"
	
	# Create musl-clang++ wrapper
	cat > "$MUSL_TOOLCHAIN_ROOT/bin/musl-clang++" <<'EOF'
#!/bin/sh
MUSL_TOOLCHAIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MUSL_SYSROOT="$MUSL_TOOLCHAIN_ROOT/sysroot"

exec clang++ \
	--sysroot="$MUSL_SYSROOT" \
	-nostdinc++ \
	-isystem "$MUSL_SYSROOT/usr/include/c++/v1" \
	-isystem "$MUSL_SYSROOT/usr/include" \
	-L"$MUSL_SYSROOT/lib" \
	-L"$MUSL_SYSROOT/usr/lib" \
	-Wl,--dynamic-linker="$MUSL_SYSROOT/lib/ld-musl-$(uname -m).so" \
	-Wl,-rpath,"$MUSL_SYSROOT/lib" \
	-Wl,-rpath,"$MUSL_SYSROOT/usr/lib" \
	"$@"
EOF
	chmod +x "$MUSL_TOOLCHAIN_ROOT/bin/musl-clang++"
	
	# Create musl-gcc compatibility wrapper
	cat > "$MUSL_TOOLCHAIN_ROOT/bin/musl-gcc" <<'EOF'
#!/bin/sh
exec "$(dirname "$0")/musl-clang" "$@"
EOF
	chmod +x "$MUSL_TOOLCHAIN_ROOT/bin/musl-gcc"
	
	# Create musl-g++ compatibility wrapper
	cat > "$MUSL_TOOLCHAIN_ROOT/bin/musl-g++" <<'EOF'
#!/bin/sh
exec "$(dirname "$0")/musl-clang++" "$@"
EOF
	chmod +x "$MUSL_TOOLCHAIN_ROOT/bin/musl-g++"
	
	# Create binutils wrappers
	# musl-nm - symbol lister
	cat > "$MUSL_TOOLCHAIN_ROOT/bin/musl-nm" <<'EOF'
#!/bin/sh
exec llvm-nm "$@"
EOF
	chmod +x "$MUSL_TOOLCHAIN_ROOT/bin/musl-nm"
	
	# musl-objdump - object file dumper
	cat > "$MUSL_TOOLCHAIN_ROOT/bin/musl-objdump" <<'EOF'
#!/bin/sh
exec llvm-objdump "$@"
EOF
	chmod +x "$MUSL_TOOLCHAIN_ROOT/bin/musl-objdump"
	
	# musl-objcopy - object file copier
	cat > "$MUSL_TOOLCHAIN_ROOT/bin/musl-objcopy" <<'EOF'
#!/bin/sh
exec llvm-objcopy "$@"
EOF
	chmod +x "$MUSL_TOOLCHAIN_ROOT/bin/musl-objcopy"
	
	# musl-strings - print strings in binary files
	cat > "$MUSL_TOOLCHAIN_ROOT/bin/musl-strings" <<'EOF'
#!/bin/sh
exec llvm-strings "$@"
EOF
	chmod +x "$MUSL_TOOLCHAIN_ROOT/bin/musl-strings"
	
	# musl-strip - strip symbols
	cat > "$MUSL_TOOLCHAIN_ROOT/bin/musl-strip" <<'EOF'
#!/bin/sh
exec llvm-strip "$@"
EOF
	chmod +x "$MUSL_TOOLCHAIN_ROOT/bin/musl-strip"
	
	# musl-ar - archiver
	cat > "$MUSL_TOOLCHAIN_ROOT/bin/musl-ar" <<'EOF'
#!/bin/sh
exec llvm-ar "$@"
EOF
	chmod +x "$MUSL_TOOLCHAIN_ROOT/bin/musl-ar"
	
	# musl-ranlib - generate archive index
	cat > "$MUSL_TOOLCHAIN_ROOT/bin/musl-ranlib" <<'EOF'
#!/bin/sh
exec llvm-ranlib "$@"
EOF
	chmod +x "$MUSL_TOOLCHAIN_ROOT/bin/musl-ranlib"
	
	# musl-readelf - display ELF file information
	cat > "$MUSL_TOOLCHAIN_ROOT/bin/musl-readelf" <<'EOF'
#!/bin/sh
exec llvm-readelf "$@"
EOF
	chmod +x "$MUSL_TOOLCHAIN_ROOT/bin/musl-readelf"
	
	# musl-size - list section sizes
	cat > "$MUSL_TOOLCHAIN_ROOT/bin/musl-size" <<'EOF'
#!/bin/sh
exec llvm-size "$@"
EOF
	chmod +x "$MUSL_TOOLCHAIN_ROOT/bin/musl-size"
	
	# musl-addr2line - convert addresses to file/line
	cat > "$MUSL_TOOLCHAIN_ROOT/bin/musl-addr2line" <<'EOF'
#!/bin/sh
exec llvm-addr2line "$@"
EOF
	chmod +x "$MUSL_TOOLCHAIN_ROOT/bin/musl-addr2line"
	
	# musl-cxxfilt - demangle C++ symbols
	cat > "$MUSL_TOOLCHAIN_ROOT/bin/musl-cxxfilt" <<'EOF'
#!/bin/sh
exec llvm-cxxfilt "$@"
EOF
	chmod +x "$MUSL_TOOLCHAIN_ROOT/bin/musl-cxxfilt"
	
	# musl-as - assembler (wrapper for clang)
	cat > "$MUSL_TOOLCHAIN_ROOT/bin/musl-as" <<'EOF'
#!/bin/sh
MUSL_TOOLCHAIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MUSL_SYSROOT="$MUSL_TOOLCHAIN_ROOT/sysroot"
exec clang -c --sysroot="$MUSL_SYSROOT" "$@"
EOF
	chmod +x "$MUSL_TOOLCHAIN_ROOT/bin/musl-as"
	
	# musl-ld - linker (wrapper for clang)
	cat > "$MUSL_TOOLCHAIN_ROOT/bin/musl-ld" <<'EOF'
#!/bin/sh
MUSL_TOOLCHAIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MUSL_SYSROOT="$MUSL_TOOLCHAIN_ROOT/sysroot"
exec clang \
	--sysroot="$MUSL_SYSROOT" \
	-fuse-ld=lld \
	-L"$MUSL_SYSROOT/lib" \
	-L"$MUSL_SYSROOT/usr/lib" \
	-Wl,--dynamic-linker="$MUSL_SYSROOT/lib/ld-musl-$(uname -m).so" \
	"$@"
EOF
	chmod +x "$MUSL_TOOLCHAIN_ROOT/bin/musl-ld"
	
	# Create pkg-config wrapper
	cat > "$MUSL_TOOLCHAIN_ROOT/bin/musl-pkg-config" <<'EOF'
#!/bin/sh
MUSL_TOOLCHAIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MUSL_SYSROOT="$MUSL_TOOLCHAIN_ROOT/sysroot"

export PKG_CONFIG_PATH="$MUSL_SYSROOT/usr/lib/pkgconfig:$MUSL_SYSROOT/usr/share/pkgconfig"
export PKG_CONFIG_SYSROOT_DIR="$MUSL_SYSROOT"
export PKG_CONFIG_LIBDIR="$MUSL_SYSROOT/usr/lib/pkgconfig"

exec pkg-config "$@"
EOF
	chmod +x "$MUSL_TOOLCHAIN_ROOT/bin/musl-pkg-config"
	
	# Install compatibility headers
	local QUEUE_URL="https://raw.githubusercontent.com/NetBSD/src/03be82a6b173b3c62116b7a186067fed3004dd44/sys/sys/queue.h"
	
	mkdir -p "$MUSL_SYSROOT/usr/include/sys"
	
	curl -L -o "$MUSL_SYSROOT/usr/include/sys/queue.h" "$QUEUE_URL"
	
	cat > "$MUSL_SYSROOT/usr/include/sys/cdefs.h" <<'CDEFS'
#ifndef MUSL_SYS_CDEFS_H
#define MUSL_SYS_CDEFS_H

#undef __P
#define __P(arg) arg

#ifdef __cplusplus
# define __BEGIN_DECLS extern "C" {
# define __END_DECLS   }
#else
# define __BEGIN_DECLS
# define __END_DECLS
#endif

#ifndef __cplusplus
# define __THROW  __attribute__ ((__nothrow__))
# define __NTH(f) __attribute__ ((__nothrow__)) f
#else
# define __THROW
# define __NTH(f) f
#endif

#define __CONCAT(x,y)	x ## y
#define __STRING(x)	#x

#ifndef __GNUC_PREREQ
# if defined __GNUC__ && defined __GNUC_VERSION__
#  define __GNUC_PREREQ(maj, min) \
	((__GNUC__ << 16) + __GNUC_MINOR__ >= ((maj) << 16) + (min))
# else
#  define __GNUC_PREREQ(maj, min) 0
# endif
#endif

#endif
CDEFS
	
	chmod 644 "$MUSL_SYSROOT/usr/include/sys/queue.h"
	chmod 644 "$MUSL_SYSROOT/usr/include/sys/cdefs.h"
	
	# Create environment setup script
	cat > "$MUSL_TOOLCHAIN_ROOT/bin/musl-env" <<'EOF'
#!/bin/sh
# Source this file to set up musl toolchain environment
MUSL_TOOLCHAIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MUSL_SYSROOT="$MUSL_TOOLCHAIN_ROOT/sysroot"

export MUSL_TOOLCHAIN_ROOT
export MUSL_SYSROOT
export PATH="$MUSL_TOOLCHAIN_ROOT/bin:$PATH"
export CC="musl-clang"
export CXX="musl-clang++"
export AR="musl-ar"
export RANLIB="musl-ranlib"
export NM="musl-nm"
export STRIP="musl-strip"
export OBJCOPY="musl-objcopy"
export OBJDUMP="musl-objdump"
export READELF="musl-readelf"
export AS="musl-as"
export LD="musl-ld"
export PKG_CONFIG="musl-pkg-config"
export CFLAGS="--sysroot=$MUSL_SYSROOT"
export CXXFLAGS="--sysroot=$MUSL_SYSROOT"
export LDFLAGS="-L$MUSL_SYSROOT/lib -L$MUSL_SYSROOT/usr/lib"

echo "Musl toolchain environment configured:"
echo "  MUSL_SYSROOT=$MUSL_SYSROOT"
echo "  CC=$CC"
echo "  CXX=$CXX"
echo "  AR=$AR (and other binutils)"
echo ""
echo "Use musl-clang or musl-gcc to compile programs"
echo "All standard binutils are available with musl- prefix"
EOF
	chmod +x "$MUSL_TOOLCHAIN_ROOT/bin/musl-env"
	
	# Create CMake toolchain file
	cat > "$MUSL_TOOLCHAIN_ROOT/share/musl-toolchain.cmake" <<'CMAKEOF'
# CMake toolchain file for musl
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR ${CMAKE_HOST_SYSTEM_PROCESSOR})

# Get the toolchain root
get_filename_component(MUSL_TOOLCHAIN_ROOT "${CMAKE_CURRENT_LIST_DIR}/.." ABSOLUTE)
set(MUSL_SYSROOT "${MUSL_TOOLCHAIN_ROOT}/sysroot")

# Specify the cross compiler
set(CMAKE_C_COMPILER clang)
set(CMAKE_CXX_COMPILER clang++)

# Compiler flags
set(CMAKE_C_FLAGS_INIT "--sysroot=${MUSL_SYSROOT}")
set(CMAKE_CXX_FLAGS_INIT "--sysroot=${MUSL_SYSROOT}")
set(CMAKE_EXE_LINKER_FLAGS_INIT "-L${MUSL_SYSROOT}/lib -L${MUSL_SYSROOT}/usr/lib")

# Search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# Search for libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH "${MUSL_SYSROOT}")
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# pkg-config
set(PKG_CONFIG_EXECUTABLE "${MUSL_TOOLCHAIN_ROOT}/bin/musl-pkg-config")
CMAKEOF
	
	# Create Meson cross-file
	cat > "$MUSL_TOOLCHAIN_ROOT/share/musl-cross.ini" <<'MESONEOF'
[binaries]
c = 'musl-clang'
cpp = 'musl-clang++'
ar = 'musl-ar'
strip = 'musl-strip'
objcopy = 'musl-objcopy'
ld = 'musl-ld'
nm = 'musl-nm'
ranlib = 'musl-ranlib'
readelf = 'musl-readelf'
size = 'musl-size'
pkg-config = 'musl-pkg-config'

[properties]
sys_root = '/opt/musl-toolchain/sysroot'
pkg_config_libdir = '/opt/musl-toolchain/sysroot/usr/lib/pkgconfig'

[host_machine]
system = 'linux'
cpu_family = 'aarch64'
cpu = 'aarch64'
endian = 'little'
MESONEOF
	
	# Create LICENSE file
	mkdir -p "$MUSL_TOOLCHAIN_ROOT/share/doc/musl"
	cat > "$MUSL_TOOLCHAIN_ROOT/share/doc/musl/LICENSE" <<'LICENSE'
This package contains compatibility headers from different sources:

1. sys/queue.h - BSD-3-Clause License (from NetBSD)
   Copyright (c) 1991, 1993 The Regents of the University of California.
   All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:
   1. Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
   2. Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
   3. Neither the name of the University nor the names of its contributors
      may be used to endorse or promote products derived from this software
      without specific prior written permission.

   THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS" AND
   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
   ARE DISCLAIMED.

2. sys/cdefs.h - Public Domain (custom implementation)

3. musl libc - MIT License
   See COPYRIGHT file in the musl source distribution
LICENSE
	
	# Create symlinks for convenience
	ln -sfv "$MUSL_TOOLCHAIN_ROOT/bin/musl-clang" "$TERMUX_PREFIX/bin/musl-clang" || true
	ln -sfv "$MUSL_TOOLCHAIN_ROOT/bin/musl-clang++" "$TERMUX_PREFIX/bin/musl-clang++" || true
	ln -sfv "$MUSL_TOOLCHAIN_ROOT/bin/musl-gcc" "$TERMUX_PREFIX/bin/musl-gcc" || true
	ln -sfv "$MUSL_TOOLCHAIN_ROOT/bin/musl-g++" "$TERMUX_PREFIX/bin/musl-g++" || true
}

termux_step_create_debscripts() {
	cat > ./postinst <<-EOF
		#!$TERMUX_PREFIX/bin/sh
		echo ""
		echo "═══════════════════════════════════════════════════════════════"
		echo "  Musl Toolchain has been installed!"
		echo "═══════════════════════════════════════════════════════════════"
		echo ""
		echo "Installation location:"
		echo "  Toolchain: $MUSL_TOOLCHAIN_ROOT"
		echo "  Sysroot:   $MUSL_SYSROOT"
		echo ""
		echo "Available compilers:"
		echo "  musl-clang   - Clang with musl sysroot"
		echo "  musl-clang++ - Clang++ with musl sysroot"
		echo "  musl-gcc     - GCC-compatible wrapper"
		echo "  musl-g++     - G++-compatible wrapper"
		echo ""
		echo "Available binutils:"
		echo "  musl-ar        - Archive manager"
		echo "  musl-ranlib    - Archive index generator"
		echo "  musl-nm        - Symbol lister"
		echo "  musl-objdump   - Object file dumper"
		echo "  musl-objcopy   - Object file copier"
		echo "  musl-strip     - Symbol stripper"
		echo "  musl-strings   - String extractor"
		echo "  musl-readelf   - ELF file viewer"
		echo "  musl-size      - Section size lister"
		echo "  musl-addr2line - Address to line converter"
		echo "  musl-cxxfilt   - C++ symbol demangler"
		echo "  musl-as        - Assembler"
		echo "  musl-ld        - Linker"
		echo ""
		echo "Usage examples:"
		echo "  # Compile a C program"
		echo "  musl-clang -static program.c -o program"
		echo ""
		echo "  # Compile with dynamic linking"
		echo "  musl-clang program.c -o program"
		echo ""
		echo "  # Use with CMake"
		echo "  cmake -DCMAKE_TOOLCHAIN_FILE=$MUSL_TOOLCHAIN_ROOT/share/musl-toolchain.cmake .."
		echo ""
		echo "  # Set up environment (for build systems)"
		echo "  source $MUSL_TOOLCHAIN_ROOT/bin/musl-env"
		echo ""
		echo "Note: This toolchain uses an isolated sysroot and does NOT"
		echo "      interfere with Termux's system libc (bionic)."
		echo ""
		echo "═══════════════════════════════════════════════════════════════"
		echo ""
	EOF
}
