TERMUX_PKG_HOMEPAGE=https://github.com/richfelker/musl-cross-make
TERMUX_PKG_DESCRIPTION="AArch64 musl cross toolchain built with musl-cross-make"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@yourname"

TERMUX_PKG_VERSION=1
TERMUX_PKG_SRCURL=git+https://github.com/richfelker/musl-cross-make.git

TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_SHA256=SKIP
TERMUX_PKG_BUILD_IN_SRC=true
# NOTE: We do NOT use TERMUX_PKG_HOSTBUILD since we want to build for Termux (ARM64)
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_pre_configure() {
    # We're building a toolchain that:
    # - RUNS on aarch64 (Termux)
    # - TARGETS aarch64-linux-musl

    # Target triple (what the compiler will produce)
    echo "TARGET = aarch64-linux-musl" > config.mak    
    
    # Installation prefix inside Termux
    echo "OUTPUT = $TERMUX_PREFIX/opt/musl-cross" >> config.mak
    
    # HOST is where the compiler will RUN (aarch64)
    # This is the key change - we need to specify the host as aarch64
    echo "HOST = aarch64-linux-gnu" >> config.mak
    
    # Use Termux's compiler to build
    echo "CC = $CC" >> config.mak
    echo "CXX = $CXX" >> config.mak
    echo "AR = $AR" >> config.mak
    echo "RANLIB = $RANLIB" >> config.mak
    echo "LD = /home/builder/buildroot/output/host/aarch64-buildroot-linux-musl/bin/ld" >> config.mak
    
    # GCC configuration
    echo "GCC_CONFIG += --enable-languages=c,c++ --disable-libquadmath --disable-decimal-float --disable-multilib --disable-bootstrap --with-native-system-header-dir=/include" >> config.mak
    
    # Binutils configuration - disable problematic posix_spawn
    echo 'BINUTILS_CONFIG += ac_cv_func_posix_spawn=no' >> config.mak
    
    # Optional: Add CFLAGS/LDFLAGS if needed
    echo "COMMON_CONFIG += CFLAGS=\"$CFLAGS\" CXXFLAGS=\"$CXXFLAGS\" LDFLAGS=\"$LDFLAGS\"" >> config.mak


}

termux_step_make() {
    # Force binutils/libiberty to NOT use posix_spawn
    export ac_cv_func_posix_spawn=no
    export ac_cv_func_posix_spawnp=no
    export LD="/home/builder/buildroot/output/host/aarch64-buildroot-linux-musl/bin/ld"
    LD="/home/builder/buildroot/output/host/aarch64-buildroot-linux-musl/bin/ld" make -j${TERMUX_PKG_MAKE_PROCESSES}
}

termux_step_make_install() {
    make install   
    
    # Convert hard links to symbolic links for Termux packaging compliance
    cd "$TERMUX_PREFIX/opt/musl-cross"
    
    # Find all hard links (files with link count > 1)
    find . -type f -links +1 | while read -r file; do
        # SKIP if the file was already turned into a symlink in a previous iteration
        if [ ! -L "$file" ] && [ "$(stat -c '%h' "$file")" -gt 1 ]; then
            # Get inode of the file
            inode=$(stat -c '%i' "$file")
            
            # Find all files with the same inode
            find . -type f -inum "$inode" | sort | {
                read -r first
                # Keep the first file as the original
                while read -r link; do
                    if [ "$link" != "$first" ]; then
                        echo "Converting hard link to symlink: $link -> $first"
                        rm -f "$link"
                        # Create relative symlink
                        ln -sf "$(realpath --relative-to="$(dirname "$link")" "$first")" "$link"
                    fi
                done
            }
        fi
    done

    # Force a successful exit code so the Termux build script continues
    return 0
}
