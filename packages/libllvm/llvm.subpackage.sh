TERMUX_SUBPKG_INCLUDE="
bin/bugpoint
bin/dsymutil
bin/llc
bin/lli
bin/llvm*
bin/obj2yaml
bin/opt
bin/sancov
bin/sanstats
bin/verify-uselistorder
bin/yaml2obj
share/opt-viewer
share/man/man1/llc.1.gz
share/man/man1/lli.1.gz
share/man/man1/llvm*
share/man/man1/opt.1.gz
share/man/man1/bugpoint.1.gz
share/man/man1/dsymutil.1.gz
share/man/man1/tblgen.1.gz
"
TERMUX_SUBPKG_DESCRIPTION="LLVM modular compiler and toolchain executables"
TERMUX_SUBPKG_BREAKS="libllvm (<< 11.0.0-1)"
TERMUX_SUBPKG_REPLACES="libllvm (<< 11.0.0-1)"
