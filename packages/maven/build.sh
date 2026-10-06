TERMUX_PKG_HOMEPAGE=https://maven.apache.org/
TERMUX_PKG_DESCRIPTION="A Java software project management and comprehension tool"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.10.0"
_JLINE_VERSION=4.4.5
TERMUX_PKG_SRCURL=(https://dlcdn.apache.org/maven/maven-3/${TERMUX_PKG_VERSION}/binaries/apache-maven-${TERMUX_PKG_VERSION}-bin.tar.gz
                   https://github.com/jline/jline3/archive/refs/tags/${_JLINE_VERSION}.tar.gz)
TERMUX_PKG_SHA256=(a46cc51bc74fa23fd267c7a0b9132b146dcf526da60d31aa5174e565632e9e0e
                   6576c19db0c5d3a5b5e20daf7c4412dff5ff9ff1fcb788361840c618b09b2b31)
TERMUX_PKG_AUTO_UPDATE=true
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

	local module module_path=""
	for module in native terminal terminal-jni jansi-core; do
		mkdir -p "classes/${module}"
		javac --release 11 -encoding UTF-8 ${module_path:+--module-path "${module_path}"} \
			-d "classes/${module}" \
			$(find "${TERMUX_PKG_SRCDIR}/jline3-${_JLINE_VERSION}/${module}/src/main/java" -name '*.java')
		cp -r "${TERMUX_PKG_SRCDIR}/jline3-${_JLINE_VERSION}/${module}/src/main/resources/." "classes/${module}/"
		local jar_name="jline-${module}-${_JLINE_VERSION}.jar"
		[[ "${module}" == jansi-core ]] && jar_name="jansi-core-${_JLINE_VERSION}.jar"
		jar --create --file "${jar_name}" -C "classes/${module}" .
		module_path="${module_path:+${module_path}:}${PWD}/${jar_name}"
	done
}

termux_step_make_install() {
	rm -f bin/*.cmd
	rm -f lib/jline-*-3.*.jar lib/jansi-core-3.*.jar
	cp jline-{native,terminal,terminal-jni}-${_JLINE_VERSION}.jar jansi-core-${_JLINE_VERSION}.jar lib/

	local arch_dirs
	case "${TERMUX_ARCH}" in
		aarch64) arch_dirs="arm64" ;;
		arm) arch_dirs="arm armv7" ;;
		i686) arch_dirs="x86" ;;
		x86_64) arch_dirs="x86_64" ;;
	esac
	rm -rf lib/jline-native/{FreeBSD,Linux,Windows}
	local d
	for d in ${arch_dirs}; do
		install -Dm644 libjlinenative.so "lib/jline-native/Linux/${d}/libjlinenative.so"
	done

	rm -rf $TERMUX_PREFIX/opt/maven
	mkdir -p $TERMUX_PREFIX/opt/maven
	find . -mindepth 1 -maxdepth 1 ! -name jline3-${_JLINE_VERSION} ! -name libjlinenative.so ! -name classes ! -name "*-${_JLINE_VERSION}.jar" \
		-exec cp -a \{\} $TERMUX_PREFIX/opt/maven/ \;
	for i in mvn mvnDebug mvnyjp; do
		ln -sfr $TERMUX_PREFIX/opt/maven/bin/$i $TERMUX_PREFIX/bin/$i
	done
}
