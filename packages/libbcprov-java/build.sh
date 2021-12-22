TERMUX_PKG_HOMEPAGE=https://www.bouncycastle.org/java.html
TERMUX_PKG_DESCRIPTION="A lightweight cryptography API for Java"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE.html"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.70
TERMUX_PKG_SRCURL=https://github.com/bcgit/bc-java/archive/refs/tags/r${TERMUX_PKG_VERSION/./rv}.tar.gz
TERMUX_PKG_SHA256=54ff39edf38ab988c4685fbbf0a9183a5fd94dee68bff36ae742f07a30acace8
TERMUX_PKG_DEPENDS="openjdk-17"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	cd prov
	local src_dirs="src/main/java ../core/src/main/java"
	javac -encoding UTF-8 -source 1.8 -target 1.8 $(find $src_dirs -name "*.java")
	_BUILD_JARFILE="$TERMUX_PKG_BUILDDIR/bcprov.jar"
	rm -f "$_BUILD_JARFILE"
	for d in $src_dirs; do
		local jar_op=u
		if [ ! -e "$_BUILD_JARFILE" ]; then
			jar_op=c
		fi
		pushd $d
		jar ${jar_op}f "$_BUILD_JARFILE" $(find . -name "*.class")
		popd
	done
}

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/share/java
	install -Dm600 "$_BUILD_JARFILE" $TERMUX_PREFIX/share/java/
}
