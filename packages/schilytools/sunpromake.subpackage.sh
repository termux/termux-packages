TERMUX_SUBPKG_DESCRIPTION="SunPro Make is a parallel make program from SUN Microsystems"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_DEPENDS="libandroid-shmem, libc++"
TERMUX_SUBPKG_INCLUDE="
bin/dmake
bin/svr4.make
lib/libmakestate*
lib/svr4.make
opt/schily/xpg4/bin/make
share/lib/make/make.rules
share/lib/make/svr4.make.rules
share/man/man1/dmake.1.gz
share/man/man1/sysV-make.1.gz
"
