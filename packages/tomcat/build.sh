TERMUX_PKG_HOMEPAGE=https://tomcat.apache.org/
TERMUX_PKG_DESCRIPTION="Open source implementation of the Jakarta Servlet, Pages and WebSocket technologies"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="11.0.26"
TERMUX_PKG_SRCURL=https://github.com/apache/tomcat/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a3b6da7d9afc73688aa71d00dd33b50d307ce047803abef7e56d63c53c38a5e9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="openjdk-21"
TERMUX_PKG_BUILD_DEPENDS="ant"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make() {
	# "deploy" builds the same tree as the official binary distribution.
	sh "$TERMUX_PREFIX/bin/ant" \
		-Dbase.path="$TERMUX_PKG_CACHEDIR/tomcat-build-libs" \
		deploy
}

termux_step_make_install() {
	rm -rf "$TERMUX_PREFIX/opt/tomcat"
	mkdir -p "$TERMUX_PREFIX/opt"
	cp -a "$TERMUX_PKG_SRCDIR/output/build" "$TERMUX_PREFIX/opt/tomcat"
	rm -f "$TERMUX_PREFIX"/opt/tomcat/bin/*.bat
	chmod +x "$TERMUX_PREFIX"/opt/tomcat/bin/*.sh
	ln -sfr "$TERMUX_PREFIX/opt/tomcat/bin/catalina.sh" "$TERMUX_PREFIX/bin/catalina"
}

termux_step_create_debscripts() {
	# Termux strips empty directories, but Tomcat needs logs/ and work/
	cat <<-EOF >./postinst
	#!${TERMUX_PREFIX}/bin/sh
	mkdir -p "${TERMUX_PREFIX}/opt/tomcat/logs" "${TERMUX_PREFIX}/opt/tomcat/work"
	EOF
}
