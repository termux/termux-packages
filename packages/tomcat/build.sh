TERMUX_PKG_HOMEPAGE=https://tomcat.apache.org/
TERMUX_PKG_DESCRIPTION="Open source implementation of the Jakarta Servlet, Pages and WebSocket technologies"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="11.0.26"
TERMUX_PKG_SRCURL="https://dlcdn.apache.org/tomcat/tomcat-11/v${TERMUX_PKG_VERSION}/bin/apache-tomcat-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=6b6ac79c15707d1d2bf54c698b1a19c046c21a56fc8ddf82a0845cc54df68324
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openjdk-21"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	rm -f bin/*.bat
	chmod +x bin/*.sh
	rm -rf "$TERMUX_PREFIX/opt/tomcat"
	mkdir -p "$TERMUX_PREFIX/opt"
	cp -a "$TERMUX_PKG_SRCDIR" "$TERMUX_PREFIX/opt/tomcat"
	ln -sfr "$TERMUX_PREFIX/opt/tomcat/bin/catalina.sh" "$TERMUX_PREFIX/bin/catalina"
}

termux_step_create_debscripts() {
	# Termux strips empty directories, but Tomcat needs logs/ and work/
	cat <<-EOF >./postinst
	#!${TERMUX_PREFIX}/bin/sh
	mkdir -p "${TERMUX_PREFIX}/opt/tomcat/logs" "${TERMUX_PREFIX}/opt/tomcat/work"
	EOF
}
