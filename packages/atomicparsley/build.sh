TERMUX_PKG_HOMEPAGE=https://bitbucket.org/wez/atomicparsley
TERMUX_PKG_DESCRIPTION="read, parse and set metadata of MPEG-4 and 3gp files"
TERMUX_PKG_VERSION=0.9.6
TERMUX_PKG_SRCURL=https://bitbucket.org/wez/atomicparsley/get/9183fff907bf.zip
TERMUX_PKG_SHA256=2c8c2ad9c400637396c43d0212a2a26d3866b15004a46525d15265d3a1543672
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_CLANG=no
termux_step_extract_package() {
	echo $PWD
	cd $TERMUX_PKG_CACHEDIR
	termux_download \
		$TERMUX_PKG_SRCURL \
		$TERMUX_PKG_CACHEDIR/9183fff907bf.zip \
		$TERMUX_PKG_SHA256
			
	unzip 9183fff907bf.zip
	mv wez-atomicparsley-9183fff907bf ../src
}
termux_step_pre_configure() {
	./autogen.sh
}
