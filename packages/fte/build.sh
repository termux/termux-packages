TERMUX_PKG_HOMEPAGE=http://fte.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A free text editor for developers"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20110708
TERMUX_PKG_SRCURL=(https://downloads.sourceforge.net/fte/fte-${TERMUX_PKG_VERSION}-src.zip
                   https://downloads.sourceforge.net/fte/fte-${TERMUX_PKG_VERSION}-common.zip)
TERMUX_PKG_SHA256=(d6311c542d3f0f2890a54a661c3b67228e27b894b4164e9faf29f014f254499e
                   58411578b31958765f42d2bf29b7aedd9f916955c2c19c96909a1c03e0246af7)
TERMUX_PKG_DEPENDS="libc++, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
TARGETS=nfte
INSTALL_NONROOT=1
PREFIX=$TERMUX_PREFIX
"
TERMUX_PKG_HOSTBUILD=true

termux_extract_src_archive() {
	rm -Rf fte
	for i in $(seq 0 $(( ${#TERMUX_PKG_SRCURL[@]}-1 ))); do
		unzip -q "$TERMUX_PKG_CACHEDIR/$(basename "${TERMUX_PKG_SRCURL[$i]}")"
	done
	mv fte "$TERMUX_PKG_SRCDIR"
}

termux_step_host_build() {
	find "$TERMUX_PKG_SRCDIR" -mindepth 1 -maxdepth 1 -exec cp -a \{\} ./ \;
	make CC="gcc -m${TERMUX_ARCH_BITS}" LDFLAGS="-m${TERMUX_ARCH_BITS}" \
		TARGETS=cfte
}

termux_step_pre_configure() {
	export PATH=$TERMUX_PKG_HOSTBUILD_DIR/src:$PATH

	CPPFLAGS+=" -DHAVE_STRLCPY -DHAVE_STRLCAT"

	echo '#include_next <ncurses.h>' > "$TERMUX_PKG_SRCDIR"/src/ncurses.h
}
