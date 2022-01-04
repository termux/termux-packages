TERMUX_PKG_HOMEPAGE=https://maven.apache.org/
TERMUX_PKG_DESCRIPTION="A Java software project management and comprehension tool"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@masterjavaofficial"
TERMUX_PKG_VERSION=3.8.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://dlcdn.apache.org/maven/maven-3/${TERMUX_PKG_VERSION}/binaries/apache-maven-${TERMUX_PKG_VERSION}-bin.tar.gz
TERMUX_PKG_SHA256=2cdc9c519427bb20fdc25bef5a9063b790e4abd930e7b14b4e9f4863d6f9f13c
TERMUX_PKG_DEPENDS="libjansi, openjdk-17"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	# Remove starter scripts for Windows
	rm -f bin/*.cmd
	# Remove DLL for Windows
	rm -rf lib/jansi-native/Windows
	ln -sf $TERMUX_PREFIX/lib/libjansi.so lib/jansi-native/
	rm -rf $TERMUX_PREFIX/opt/maven
	mkdir -p $TERMUX_PREFIX/opt
	cp -a $TERMUX_PKG_SRCDIR $TERMUX_PREFIX/opt/maven/
	# Symlink only starter scripts for Linux
	ln -sfr $TERMUX_PREFIX/opt/maven/bin/mvn $TERMUX_PREFIX/bin/mvn
	ln -sfr $TERMUX_PREFIX/opt/maven/bin/mvnDebug $TERMUX_PREFIX/bin/mvnDebug
	ln -sfr $TERMUX_PREFIX/opt/maven/bin/mvnyjp $TERMUX_PREFIX/bin/mvnyjp
}
