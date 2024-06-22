TERMUX_SUBPKG_INCLUDE="
bin/FileCheck
bin/UnicodeNameMappingGenerator
bin/count
bin/lli-child-target
bin/llvm-PerfectShuffle
bin/llvm-jitlink-executor
bin/not
bin/obj2yaml
bin/yaml-bench
bin/yaml2obj
share/man/man1/FileCheck.1.gz
"
TERMUX_SUBPKG_DESCRIPTION="LLVM Development Tools"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_DEPENDS="libc++, ncurses, zlib, zstd"
TERMUX_SUBPKG_BREAKS="libllvm (<< 16.0.0)"
TERMUX_SUBPKG_REPLACES="libllvm (<< 16.0.0)"
