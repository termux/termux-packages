TERMUX_PKG_HOMEPAGE=https://github.com/mjuhasz/BDSup2Sub
TERMUX_PKG_DESCRIPTION="A subtitle conversion tool for image based stream formats"
TERMUX_PKG_LICENSE="Apache-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.0.1
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://github.com/mjuhasz/BDSup2Sub/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8ad9529e58d2eeadb5c2be80bfcdaaa06a8714c3144c327491c1d19431993ad9
TERMUX_PKG_DEPENDS="openjdk-17"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	cp -T $TERMUX_PKG_BUILDER_DIR/src-Manifest.txt src/Manifest.txt
}

termux_step_pre_configure() {
	_BUILD_JARFILE="$TERMUX_PKG_BUILDDIR/${TERMUX_PKG_NAME}.jar"
}

termux_step_make() {
	cd src
	javac -encoding UTF-8 -source 1.8 -target 1.8 $(find . -name "*.java")
	rm -f "${_BUILD_JARFILE}"
	jar cfm "${_BUILD_JARFILE}" Manifest.txt $(find . -name "*.class")
}

termux_step_make_install() {
	local _JAR_DIR=$TERMUX_PREFIX/share/java
	install -Dm600 -t ${_JAR_DIR} "${_BUILD_JARFILE}"

	local exe=$TERMUX_PREFIX/bin/bdsup2sub
	mkdir -p $(dirname ${exe})
	rm -f ${exe}
	cat <<-EOF > ${exe}
		#!$TERMUX_PREFIX/bin/sh
		exec java -jar ${_JAR_DIR}/$(basename "${_BUILD_JARFILE}") "\$@"
	EOF
	chmod 0700 ${exe}
}
