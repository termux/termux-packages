TERMUX_PKG_HOMEPAGE=https://android.googlesource.com/platform/bionic/
TERMUX_PKG_DESCRIPTION="bionic libc, libm, libdl and dynamic linker for ubuntu host"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="8.0.0-r51"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=6b42a86fc2ec58f86862a8f09a5465af0758ce24f2ca8c3cabb3bb6a81d96525
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SKIP_SRC_EXTRACT=true

termux_step_get_source() {
    if $TERMUX_ON_DEVICE_BUILD; then
        termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
    fi
    
    case "${TERMUX_ARCH}" in
        i686) _ARCH=x86 ;;
        aarch64) _ARCH=arm64 ;;
        *) _ARCH=${TERMUX_ARCH} ;;
    esac

    export LD_LIBRARY_PATH="${TERMUX_PKG_SRCDIR}/prefix/lib/x86_64-linux-gnu:${TERMUX_PKG_SRCDIR}/prefix/usr/lib/x86_64-linux-gnu"
    export PATH="$(sed "s#/home/`whoami`/.cargo/bin:##" <<< $PATH):${TERMUX_PKG_SRCDIR}/prefix/usr/bin:$PATH"

    mkdir -p ${TERMUX_PKG_SRCDIR}/prefix
    cd ${TERMUX_PKG_SRCDIR}

    cp -f ${TERMUX_PKG_BUILDER_DIR}/LICENSE.txt ${TERMUX_PKG_SRCDIR}/LICENSE.txt

    local PACKAGES=(
        "http://security.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.4-2ubuntu0.1_amd64.deb a5acc48e56ca4cd1b2e5fb22b36c5a02788c0baede55617e3f30decff58616ab"
        "http://security.ubuntu.com/ubuntu/pool/universe/n/ncurses/libncurses5_6.4-2ubuntu0.1_amd64.deb 654b4f5b41380efabf606a691174974f9304e0b3ee461d0d91712b7e024f5546"
        "http://mirrors.kernel.org/ubuntu/pool/main/o/openssh/openssh-client_8.9p1-3ubuntu0.4_amd64.deb afb16d53e762a78fabd9ce405752cd35d2f45904355ee820ce00f67bdf530155"
    )
    for item in "${PACKAGES[@]}"; do
        local URL=$(cut -d' ' -f1 <<< $item) SHA256=$(cut -d' ' -f2 <<< $item)
        termux_download ${URL} ${TERMUX_PKG_CACHEDIR}/${URL##*/} ${SHA256}

        mkdir -p ${TERMUX_PKG_TMPDIR}/${URL##*/}
        ar x ${TERMUX_PKG_CACHEDIR}/${URL##*/} --output=${TERMUX_PKG_TMPDIR}/${URL##*/}
        tar xf ${TERMUX_PKG_TMPDIR}/${URL##*/}/data.tar.zst -C ${TERMUX_PKG_SRCDIR}/prefix
    done

    termux_download \
        https://storage.googleapis.com/git-repo-downloads/repo \
        ${TERMUX_PKG_CACHEDIR}/repo \
        df6e4f72ef21d839b4352f376ab9428e303a1414ac7a1f21fe420069b2acd476
    chmod +x ${TERMUX_PKG_CACHEDIR}/repo
    ${TERMUX_PKG_CACHEDIR}/repo init \
        -u https://android.googlesource.com/platform/manifest \
        -b main -m ${TERMUX_PKG_BUILDER_DIR}/default.xml
    ${TERMUX_PKG_CACHEDIR}/repo sync -c -j32

    sed -i '1s|.*|\#!'${TERMUX_PKG_SRCDIR}'/prebuilts/python/linux-x86/2.7.5/bin/python2|' ${TERMUX_PKG_SRCDIR}/bionic/libc/fs_config_generator.py
    sed -i '1s|.*|\#!'${TERMUX_PKG_SRCDIR}'/prebuilts/python/linux-x86/2.7.5/bin/python2|' ${TERMUX_PKG_SRCDIR}/external/clang/clang-version-inc.py
    sed -i '/selinux/d' ${TERMUX_PKG_SRCDIR}/system/core/debuggerd/Android.bp
    sed -i '/selinux/d' ${TERMUX_PKG_SRCDIR}/system/core/debuggerd/crash_dump.cpp
    sed -i '/selinux/d' ${TERMUX_PKG_SRCDIR}/system/core/debuggerd/debuggerd.cpp
}

termux_step_configure() {
    :
}

termux_step_make() {
    env -i LD_LIBRARY_PATH=$LD_LIBRARY_PATH PATH=$PATH bash -c "
        set -e;
        cd ${TERMUX_PKG_SRCDIR}
        source build/envsetup.sh;
        lunch aosp_${_ARCH}-eng;
        make JAVA_NOT_REQUIRED=true linker libc libm libdl libicuuc debuggerd crash_dump
    "
}

termux_step_make_install() {
    mkdir -p ${TERMUX_PREFIX}/opt/bionic-host/usr/icu
    cp ${TERMUX_PKG_SRCDIR}/external/icu/icu4c/source/stubdata/icudt58l.dat ${TERMUX_PREFIX}/opt/bionic-host/usr/icu/
    cp -r ${TERMUX_PKG_SRCDIR}/out/target/product/generic*/system/* ${TERMUX_PREFIX}/opt/bionic-host/
}
