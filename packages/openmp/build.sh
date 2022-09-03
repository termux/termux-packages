TERMUX_PKG_HOMEPAGE=https://openmp.llvm.org/
TERMUX_PKG_DESCRIPTION="LLVM OpenMP Runtime Library"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=14.0.6
TERMUX_PKG_SRCURL=https://github.com/llvm/llvm-project/releases/download/llvmorg-${TERMUX_PKG_VERSION}/openmp-${TERMUX_PKG_VERSION}.src.tar.xz
TERMUX_PKG_SHA256=4f731ff202add030d9d68d4c6daabd91d3aeed9812e6a5b4968815cfdff0eb1f
TERMUX_PKG_DEPENDS="libllvm-static, libelf, libffi"
