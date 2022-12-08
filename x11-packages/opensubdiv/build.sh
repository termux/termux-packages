TERMUX_PKG_HOMEPAGE=https://graphics.pixar.com/opensubdiv/docs/intro.html
TERMUX_PKG_DESCRIPTION="A set of open source libraries that implement high performance subdivision surface (subdiv) evaluation"
# License: Modified Apache 2.0 License
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt, NOTICE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.5.0
TERMUX_PKG_SRCURL=https://github.com/PixarAnimationStudios/OpenSubdiv/archive/refs/tags/v${TERMUX_PKG_VERSION//./_}.tar.gz
TERMUX_PKG_SHA256=8f5044f453b94162755131f77c08069004f25306fd6dc2192b6d49889efb8095
TERMUX_PKG_DEPENDS="libc++, libtbb, mesa"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DNO_EXAMPLES=ON
-DNO_TUTORIALS=ON
-DNO_PTEX=ON
-DNO_DOC=ON
-DNO_CUDA=ON
-DNO_OPENCL=ON
-DNO_TESTS=ON
-DNO_GLFW=ON
"
