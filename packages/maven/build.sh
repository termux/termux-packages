TERMUX_PKG_HOMEPAGE=https://maven.apache.org/
TERMUX_PKG_DESCRIPTION="A Java software project management and comprehension tool"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.9.11"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://dlcdn.apache.org/maven/maven-3/${TERMUX_PKG_VERSION}/binaries/apache-maven-${TERMUX_PKG_VERSION}-bin.tar.gz
TERMUX_PKG_SHA256=4b7195b6a4f5c81af4c0212677a32ee8143643401bc6e1e8412e6b06ea82beac
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libjansi (>= 2.4.0-1), openjdk-21"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	# Remove starter scripts for Windows
	rm -f bin/*.cmd
	# Remove DLL for Windows
	rm -rf lib/jansi-native/Windows
	ln -sf $TERMUX_PREFIX/lib/jansi/libjansi.so lib/jansi-native/
	rm -rf $TERMUX_PREFIX/opt/maven
	mkdir -p $TERMUX_PREFIX/opt
	cp -a $TERMUX_PKG_SRCDIR $TERMUX_PREFIX/opt/maven/
	# Symlink only starter scripts for Linux
	for i in mvn mvnDebug mvnyjp; do
		ln -sfr $TERMUX_PREFIX/opt/maven/bin/$i $TERMUX_PREFIX/bin/$i
	done
}
