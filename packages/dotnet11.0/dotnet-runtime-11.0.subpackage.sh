TERMUX_SUBPKG_DESCRIPTION=".NET 11.0 Runtime"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_DEPENDS="dotnet-hostfxr-11.0 (= ${TERMUX_PKG_FULLVERSION}), libandroid-posix-semaphore, libicu, openssl, zlib"
TERMUX_SUBPKG_INCLUDE=$(cat "${TERMUX_PKG_TMPDIR}"/dotnet-runtime.txt)
