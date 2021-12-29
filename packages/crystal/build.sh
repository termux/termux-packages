TERMUX_PKG_HOMEPAGE=https://crystal-lang.org/
TERMUX_PKG_DESCRIPTION="A language for humans and computers"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@leapofazzam123"
TERMUX_PKG_VERSION=1.2.2
TERMUX_PKG_SRCURL=https://github.com/crystal-lang/crystal/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=6d963a71ef5f6c73faa272a0f81b50e9ddbf814b1ec07e557ce5c95f84d6077e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libllvm, libgc, libevent, pcre"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	find "$TERMUX_PKG_SRCDIR" -mindepth 1 -maxdepth 1 -exec cp -a \{\} ./ \;
	make PREFIX=$TERMUX_PKG_HOSTBUILD_DIR/crystal-host clean crystal install
}

termux_step_make() {
	make clean deps CXX=$CXX CRYSTAL=$TERMUX_PKG_HOSTBUILD_DIR/crystal-host/bin/crystal

	$TERMUX_PKG_HOSTBUILD_DIR/crystal-host/bin/crystal build --cross-compile \
		--target aarch64-unknown-linux-musl src/compiler/crystal.cr \
		-Dwithout_playground

	$CC crystal.o -o .build/crystal -rdynamic src/llvm/ext/llvm_ext.o \
		`$TERMUX_PKG_HOSTBUILD_DIR/bin/llvm-config --libs --system-libs --ldflags` \
		-lstdc++ -lpcre -lm -lgc -lpthread -levent -lrt -ldl

	[ -d "shards" ] || \
		git clone "https://github.com/crystal-lang/shards.git" && \
		git -C shards pull && \
		git -C shards reset --hard ff94dd2ee46791e8e331f725fa1e4acdc13d5e9f

	cd shards
	make release=1 CRYSTAL=$TERMUX_PKG_HOSTBUILD_DIR/crystal-host/bin/crystal SHARDS=false
}

termux_step_make_install() {
	install -Dm700 "$TERMUX_PKG_BUILDDIR"/.build/crystal "$TERMUX_PREFIX"/bin/crystal
	install -Dm700 "$TERMUX_PKG_BUILDDIR"/shards/bin/shards "$TERMUX_PREFIX"/bin/shards
	install -Dm600 "$TERMUX_PKG_SRCDIR"/man/crystal.1 "$TERMUX_PREFIX"/share/man/man1/crystal.1
	install -Dm600 "$TERMUX_PKG_SRCDIR"/etc/completion.bash "$TERMUX_PREFIX"/share/bash-completion/completions/crystal
	install -Dm600 "$TERMUX_PKG_SRCDIR"/etc/completion.zsh "$TERMUX_PREFIX"/share/zsh/site-functions/_crystal

	mkdir -p "$TERMUX_PREFIX/lib/crystal"
	cp -r "$TERMUX_PKG_SRCDIR"/src/* "$TERMUX_PREFIX/lib/crystal"
}
