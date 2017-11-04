TERMUX_PKG_VERSION=4.0.0
TERMUX_PKG_HOMEPAGE=https://github.com/hashcat/hashcat
TERMUX_PKG_DESCRIPTION="World's fastest and most advanced password recovery utility "
_COMMIT=v$TERMUX_PKG_VERSION
TERMUX_PKG_SRCURL="https://github.com/hashcat/hashcat/archive/${_COMMIT}.zip"                                       
TERMUX_PKG_DEPENDS="ocl-icd"
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_SHA256=471da8510aaded44bb066fe6cd41bf55a513e72ff9a47cab32da7e5e5be7d882

#termux_step_pre_configure() 
#{	
#	LDFLAGS+=" -ldl"
#}


termux_step_make () {
	make CC=clang OPENCL_HEADERS_KHRONOS="$PREFIX/include" VERSION_TAG="$TERMUX_PKG_VERSION" 
}
