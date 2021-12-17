TERMUX_PKG_HOMEPAGE=https://crystal-lang.org/
TERMUX_PKG_DESCRIPTION="A language for humans and computers"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@leapofazzam123"
TERMUX_PKG_VERSION=1.2.2
TERMUX_PKG_SRCURL=https://github.com/crystal-lang/crystal/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=6d963a71ef5f6c73faa272a0f81b50e9ddbf814b1ec07e557ce5c95f84d6077e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="llvm, libllvm, libgc"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
release=1
stats=1
threads=$TERMUX_MAKE_PROCESSES
LLVM_CONFIG=$TERMUX_PREFIX/bin/llvm-config
CRYSTAL_CONFIG_VERSION=1.2.2
CRYSTAL_CONFIG_PATH=lib:$TERMUX_PREFIX/lib/crystal
"

termux_step_make_install() {
	install -Dm700 "$TERMUX_PKG_SRCDIR"/.build/crystal "$TERMUX_PREFIX"/bin/crystal
	install -Dm600 "$TERMUX_PKG_SRCDIR"/man/crystal.1 "$TERMUX_PREFIX"/share/man/man1/crystal.1
	install -Dm600 "$TERMUX_PKG_SRCDIR"/etc/completion.bash \
		"$TERMUX_PREFIX"/share/bash-completion/completions/crystal
	install -Dm600 "$TERMUX_PKG_SRCDIR"/etc/completion.zsh \
		"$TERMUX_PREFIX"/share/zsh/site-functions/_crystal

	mkdir -p "$TERMUX_PREFIX/lib/crystal"
	cp -r "$TERMUX_PKG_SRCDIR"/src/* "$TERMUX_PREFIX/lib/crystal"

	cd "$TERMUX_PREFIX/lib/crystal"
	rm llvm/ext/llvm_ext.o
}
