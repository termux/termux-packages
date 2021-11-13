TERMUX_PKG_HOMEPAGE=https://maven.apache.org/
TERMUX_PKG_DESCRIPTION="A Java software project management and comprehension tool"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@masterjavaofficial"
TERMUX_PKG_VERSION=3.8.3
TERMUX_PKG_SRCURL=https://dlcdn.apache.org/maven/maven-3/${TERMUX_PKG_VERSION}/binaries/apache-maven-${TERMUX_PKG_VERSION}-bin.tar.gz
TERMUX_PKG_SHA256=0f1597d11085b8fe93d84652a18c6deea71ece9fabba45a02cf6600c7758fd5b
TERMUX_PKG_DEPENDS="openjdk-17"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	# Remove starter scripts for Windows
	rm -f bin/*.cmd
	# Remove DLL for Windows
	rm -rf lib/jansi-native/Windows
	rm -rf $TERMUX_PREFIX/opt/maven
	mkdir -p $TERMUX_PREFIX/opt
	cp -a $TERMUX_PKG_SRCDIR $TERMUX_PREFIX/opt/maven/
	# Symlink only starter scripts for Linux
	ln -sfr $TERMUX_PREFIX/opt/maven/bin/mvn $TERMUX_PREFIX/bin/mvn
	ln -sfr $TERMUX_PREFIX/opt/maven/bin/mvnDebug $TERMUX_PREFIX/bin/mvnDebug
	ln -sfr $TERMUX_PREFIX/opt/maven/bin/mvnyjp $TERMUX_PREFIX/bin/mvnyjp
}
