#!/bin/bash
# Script to build clang with patch to make executables
# position-independent on Android by default.
# Currently unused as the clang binary in the NDK is used
# instead, wrapped with clang-pie-wrapper.

set -e -u

LLVM_VERSION=3.9.1

rm -Rf $HOME/clang-build
mkdir -p $HOME/clang-build
cd $HOME/clang-build

curl -L --fail --retry 2 -o llvm.tar.xz \
	http://llvm.org/releases/${LLVM_VERSION}/llvm-${LLVM_VERSION}.src.tar.xz
TERMUX_PKG_SHA256=1fd90354b9cf19232e8f168faf2220e79be555df3aa743242700879e8fd329ee
curl -L --fail --retry 2 -o clang.tar.xz \
	http://llvm.org/releases/${LLVM_VERSION}/cfe-${LLVM_VERSION}.src.tar.xz

tar xf llvm.tar.xz
tar xf clang.tar.xz

mv llvm-3.9.1.src src
mv cfe-$LLVM_VERSION.src src/tools/clang
cd src

patch -p1 <<EOF
diff -u -r ../llvm-3.9.0.src/tools/clang/lib/Driver/Tools.cpp ./tools/clang/lib/Driver/Tools.cpp
--- ../llvm-3.9.0.src/tools/clang/lib/Driver/Tools.cpp	2016-08-13 16:43:56.000000000 -0400
+++ ./tools/clang/lib/Driver/Tools.cpp	2016-09-04 06:15:59.703422745 -0400
@@ -9357,9 +9357,12 @@
   const llvm::Triple::ArchType Arch = ToolChain.getArch();
   const bool isAndroid = ToolChain.getTriple().isAndroid();
   const bool IsIAMCU = ToolChain.getTriple().isOSIAMCU();
+  // Termux modification: Enable pie by default for Android and support the
+  // nopie flag.
   const bool IsPIE =
       !Args.hasArg(options::OPT_shared) && !Args.hasArg(options::OPT_static) &&
-      (Args.hasArg(options::OPT_pie) || ToolChain.isPIEDefault());
+      (Args.hasArg(options::OPT_pie) || ToolChain.isPIEDefault() || isAndroid) &&
+      !Args.hasArg(options::OPT_nopie);
   const bool HasCRTBeginEndFiles =
       ToolChain.getTriple().hasEnvironment() ||
       (ToolChain.getTriple().getVendor() != llvm::Triple::MipsTechnologies);
EOF

mkdir ../build
cd ../build

cmake ../src \
	-DCMAKE_BUILD_TYPE=Release
make clang
