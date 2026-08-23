TERMUX_PKG_HOMEPAGE=https://nim-lang.org/
TERMUX_PKG_DESCRIPTION="Nim programming language compiler"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2.6
TERMUX_PKG_SRCURL="https://nim-lang.org/download/nim-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=657b0e3d5def788148d2a87fa6123fa755b2d92cad31ef60fd261e451785528b
TERMUX_PKG_DEPENDS="clang, git, libandroid-glob, openssl, libandroid-spawn"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_nim
	declare -ag _NIM_TOOLS=(
		"koch"
		"dist/nimble/src/nimble"
		"nimpretty/nimpretty"
		"nimsuggest/nimsuggest"
		"testament/testament"
		"tools/nimgrep"
	)
}

termux_step_make() {
	NIM_ARCH="$TERMUX_ARCH"
	case "$TERMUX_ARCH" in
		"aarch64") NIM_ARCH="arm64";;
		"i686")    NIM_ARCH="i386";;
		"x86_64")
			NIM_ARCH="amd64"
			sed -i 's/arm64/amd64/g' makefile
			;;
	esac
	export NIM_ARCH
	CFLAGS+=" $CPPFLAGS -w -fno-strict-aliasing"
	LDFLAGS+=" -landroid-glob -landroid-spawn"

	for cmd in "${_NIM_TOOLS[@]}"; do
		case "$cmd" in
			"koch") nim_flags="--opt:size";;
			"dist/nimble/src/nimble") nim_flags="-d:nimNimbleBootstrap";; # See: https://github.com/nim-lang/nimble/issues/1248
			*) nim_flags="";;
		esac
		(
			cd "$(dirname "$cmd")" && \
			nim \
				--cc:clang \
				--clang.exe="$CC" \
				--clang.linkerexe="$CC" \
				--cpu:"$NIM_ARCH" \
				--define:termux \
				--os:android \
				-d:"tempDir:$TERMUX_PREFIX/tmp" \
				-d:release \
				-d:sslVersion=3 \
				-l:"$LDFLAGS -landroid-glob" \
				-t:"$CPPFLAGS $CFLAGS" \
				$nim_flags \
				c \
				"$(basename "$cmd").nim"
		)
	done

	sed -i \
		-e "s|@CC@|${CC}|g" \
		-e "s|@CFLAGS@|${CFLAGS}|g" \
		-e "s|@LDFLAGS@|${LDFLAGS}|g" \
		-e "s|@CPPFLAGS@|${CPPFLAGS}|g" \
		config/nim.cfg

	make \
		-j "$TERMUX_PKG_MAKE_PROCESSES" \
		LD="$CC" \
		mycpu="$NIM_ARCH" \
		myos=android \
		uos=linux \
		useShPath="$TERMUX_PREFIX/bin/sh"
}

termux_step_make_install() {
	./install.sh "$TERMUX_PREFIX/lib"
	ln -sfr "$TERMUX_PREFIX/lib/nim/bin/nim" "$TERMUX_PREFIX/bin/"
	for cmd in "${_NIM_TOOLS[@]}"; do
		cp "$cmd" "$TERMUX_PREFIX/lib/nim/bin/"
		ln -sfr "$TERMUX_PREFIX/lib/nim/bin/$(basename "$cmd")" "$TERMUX_PREFIX/bin/"
	done
	mkdir -p "$TERMUX_PREFIX/lib/nim/tools"
	cp -r tools/dochack "$TERMUX_PREFIX/lib/nim/tools/"
}
