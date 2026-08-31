TERMUX_PKG_HOMEPAGE=https://github.com/veracrypt/VeraCrypt
TERMUX_PKG_DESCRIPTION="VeraCrypt disk encryption manager for Termux"
TERMUX_PKG_LICENSE="Apache-2.0, TrueCrypt-3.0"
TERMUX_PKG_MAINTAINER="Infiniti151 <43163551+Infiniti151@users.noreply.github.com>"
TERMUX_PKG_VERSION="1.26.29"
WX_VERSION="3.2.11"
WX_DIR="$TERMUX_PKG_SRCDIR/wxWidgets-${WX_VERSION}"
TERMUX_PKG_SRCURL=(
    "https://github.com/veracrypt/VeraCrypt/releases/download/VeraCrypt_${TERMUX_PKG_VERSION}/VeraCrypt_${TERMUX_PKG_VERSION}_Source.tar.bz2" \
    "https://github.com/wxWidgets/wxWidgets/releases/download/v${WX_VERSION}/wxWidgets-${WX_VERSION}.tar.bz2" \
)
TERMUX_PKG_SHA256=(
    "60826731e2982b4bd231e3930e85a44391169638671a1b200c518f8c8b46cb2a" \
    "6a129015bce2e914e4bf61ec4411854ad962801d47e92f2eb8340adb6a90af08" \
)
TERMUX_PKG_DEPENDS="libfuse3, libpcsclite, libdevmapper"
TERMUX_PKG_BUILD_IN_SRC=true
: ${TERMUX_MAKE_PROCESSES:=$(nproc)}

termux_step_pre_configure() {
    # Update compiler wrappers to strip x86-specific SIMD/crypto flags
    cat > "$TERMUX_PKG_BUILDDIR/clang-wrapper" << EOF
#!/bin/bash
filtered_args=()
for arg in "\$@"; do
    case "\$arg" in
        -msse2|-maes) ;;
        *) filtered_args+=("\$arg") ;;
    esac
done
exec $CC "\${filtered_args[@]}"
EOF

    cat > "$TERMUX_PKG_BUILDDIR/clang++-wrapper" << EOF
#!/bin/bash
filtered_args=()
for arg in "\$@"; do
    case "\$arg" in
        -msse2|-maes) ;;
        *) filtered_args+=("\$arg") ;;
    esac
done
exec $CXX "\${filtered_args[@]}"
EOF

    chmod +x "$TERMUX_PKG_BUILDDIR/clang-wrapper" "$TERMUX_PKG_BUILDDIR/clang++-wrapper"

    export CC="$TERMUX_PKG_BUILDDIR/clang-wrapper"
    export CXX="$TERMUX_PKG_BUILDDIR/clang++-wrapper"

    cd "$WX_DIR"

    # Neutralize legacy Android config AND chkconf files before configure/build
    echo "/* Bypassed for autoconf build */" > include/wx/android/config_android.h
    echo "/* Bypassed for autoconf build */" > include/wx/android/chkconf.h

    ./configure \
        --host=$TERMUX_HOST_PLATFORM \
        --disable-gui \
        --disable-intl \
        --disable-shared \
        --disable-tests \
        --enable-unicode \
        --enable-cmdline \
        --with-zlib=builtin \
        --with-regex=builtin \
        CFLAGS="$CFLAGS -fPIC -D_GNU_SOURCE -DHAVE_UNISTD_H -Wno-error=implicit-function-declaration" \
        CXXFLAGS="$CXXFLAGS -fPIC -D_GNU_SOURCE -DHAVE_UNISTD_H -Wno-error=implicit-function-declaration" \
        CPPFLAGS="-DHAVE_UNISTD_H"

    make -j$TERMUX_MAKE_PROCESSES
}

termux_step_make() {
    WX_FLAGS="$("$WX_DIR/wx-config" --cxxflags)"
    ARM_FLAGS="-march=armv8-a+crypto"

    # Prevent execution on host
    sed -i 's|./$(APPNAME)|true|g' Main/Main.make

    # Neutralize strip everywhere
    sed -i 's|\bstrip\b|true|g' Main/Main.make

    make -j$TERMUX_MAKE_PROCESSES \
        NOGUI=1 \
        WXSTATIC=1 \
        WITHFUSE3=1 \
        ARCH=aarch64 \
        PLATFORM_ARCH=aarch64 \
        WX_ROOT="$WX_DIR" \
        WX_CONFIG="$WX_DIR/wx-config" \
        TC_EXTRA_CFLAGS="$WX_FLAGS $ARM_FLAGS" \
        TC_EXTRA_CXXFLAGS="$WX_FLAGS $ARM_FLAGS -D'_(s)=wxString(s)'"
}

termux_step_make_install() {
    install -Dm755 "Main/veracrypt" "$TERMUX_PREFIX/bin/veracrypt"
}