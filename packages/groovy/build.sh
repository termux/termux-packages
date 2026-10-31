TERMUX_PKG_HOMEPAGE=https://groovy-lang.org/
TERMUX_PKG_DESCRIPTION="A powerful multi-faceted programming language for the JVM platform"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.0.0"
_JLINE_VERSION=4.4.5
TERMUX_PKG_SRCURL=(https://downloads.apache.org/groovy/$TERMUX_PKG_VERSION/distribution/apache-groovy-binary-$TERMUX_PKG_VERSION.zip
                   https://github.com/jline/jline3/archive/refs/tags/${_JLINE_VERSION}.tar.gz)
TERMUX_PKG_SHA256=(54ab1a877f01da2ed16ed43c1ed7a8d6c36b122714c6959712700e89e6efde7c
                   6576c19db0c5d3a5b5e20daf7c4412dff5ff9ff1fcb788361840c618b09b2b31)
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="openjdk-21"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	local jni_dir="${TERMUX_PREFIX}/lib/jvm/java-21-openjdk/include"
	local native_dir="${TERMUX_PKG_SRCDIR}/jline3-${_JLINE_VERSION}/native/src/main/native"
	$CC $CFLAGS $CPPFLAGS -fPIC -fvisibility=hidden \
		-I"${jni_dir}" -I"${jni_dir}/linux" -shared \
		-o libjlinenative.so \
		"${native_dir}"/jlinenative.c "${native_dir}"/clibrary.c "${native_dir}"/kernel32.c \
		$LDFLAGS

	local arch_dirs
	case "${TERMUX_ARCH}" in
		aarch64) arch_dirs="arm64" ;;
		arm) arch_dirs="arm armv7" ;;
		i686) arch_dirs="x86" ;;
		x86_64) arch_dirs="x86_64" ;;
	esac
	local d
	for d in ${arch_dirs}; do
		install -Dm644 libjlinenative.so "native-libs/org/jline/nativ/Linux/${d}/libjlinenative.so"
	done
	jar uf lib/jline-native-${_JLINE_VERSION}.jar -C native-libs org
	jar uf lib/jansi-${_JLINE_VERSION}.jar -C native-libs org
}

termux_step_make_install() {
	rm -f ./bin/*.bat
	rm -rf $TERMUX_PREFIX/opt/groovy
	mkdir -p $TERMUX_PREFIX/opt/groovy
	find . -mindepth 1 -maxdepth 1 ! -name jline3-${_JLINE_VERSION} ! -name native-libs ! -name libjlinenative.so -exec cp -r \{\} $TERMUX_PREFIX/opt/groovy/ \;
	for i in grape groovy groovyc groovyConsole groovydoc groovysh java2groovy startGroovy; do
		ln -sfr $TERMUX_PREFIX/opt/groovy/bin/$i $TERMUX_PREFIX/bin/$i
	done
}
