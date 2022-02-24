TERMUX_SUBPKG_INCLUDE="
bin/lli-child-target
bin/llvm-jitlink-executor
bin/obj2yaml
bin/yaml2obj
bin/count
bin/FileCheck
bin/not
bin/llvm-PerfectShuffle
bin/yaml-bench
share/man/man1/FileCheck.1.gz
"
TERMUX_SUBPKG_DESCRIPTION="LLVM Development Tools"
TERMUX_SUBPKG_BREAKS="libllvm (<< 11.0.0-1)"
TERMUX_SUBPKG_REPLACES="libllvm (<< 11.0.0-1)"
