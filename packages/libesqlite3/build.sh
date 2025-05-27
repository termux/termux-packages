TERMUX_PKG_HOMEPAGE="https://github.com/ericsink/SQLitePCL.raw"
TERMUX_PKG_DESCRIPTION="SQLitePCLRaw is a Portable Class Library for low-level access to SQLite (native library)"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT="cd2922b8867e4360f0976601414bd24a3ad613d8"
_COMMIT_DATE="20250307"
TERMUX_PKG_VERSION="3.49.1.$_COMMIT_DATE"
TERMUX_PKG_SRCURL="https://github.com/ericsink/cb/archive/${_COMMIT}.tar.gz"
TERMUX_PKG_SHA256=4893433d7ff2e12e7ac35095a80710004f496fa4ec2527a3b188fad3d8a6f7e2
TERMUX_PKG_EXCLUDED_ARCHES="arm"

termux_step_make() {
	termux_setup_dotnet
	local _target_cpu=""
	case "$TERMUX_ARCH" in
		aarch64) _target_cpu="arm64" ;;
		arm) _target_cpu="armhf" ;;
		x86_64) _target_cpu="x64" ;;
		i686) _target_cpu="x86" ;;
		*) termux_error_exit  "Unsupported arch: $TERMUX_ARCH"
	esac

	echo "Building libe_sqlite3.so"
	( cd "${TERMUX_PKG_SRCDIR}/bld" && dotnet run && "$CC" $CFLAGS @linux_e_sqlite3_"${_target_cpu}".gccargs -lm -ldl )
	termux_dotnet_kill

	cp "${TERMUX_PKG_SRCDIR}/bld/bin/e_sqlite3/linux/${_target_cpu}/libe_sqlite3.so" "$TERMUX_PKG_BUILDDIR"
}

termux_step_make_install() {
	install -Dm600 -t "${TERMUX_PREFIX}/lib" "${TERMUX_PKG_BUILDDIR}/libe_sqlite3.so"
}
