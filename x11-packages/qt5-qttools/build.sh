TERMUX_PKG_HOMEPAGE=https://www.qt.io/
TERMUX_PKG_DESCRIPTION="Qt Development Tools (Linguist, Assistant, Designer, etc.)"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=5.12.10
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL="https://download.qt.io/official_releases/qt/5.12/${TERMUX_PKG_VERSION}/submodules/qttools-everywhere-src-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=b0cfa6e7aac41b7c61fc59acc04843d7a98f9e1840370611751bcfc1834a636c
TERMUX_PKG_DEPENDS="qt5-qtbase, qt5-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, clang"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true

# Ignore the bootstrap library that is touched by the hijack
TERMUX_PKG_RM_AFTER_INSTALL="
opt/qt/cross/lib/libQt5Bootstrap.*
"

# Replacing the old qt5-base packages
TERMUX_PKG_REPLACES="qt5-tools"

termux_step_pre_configure () {
    #######################################################
    ##
    ##  Hijack the bootstrap library
    ##
    #######################################################
    for i in a prl; do
        cp -p "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5Bootstrap.${i}" \
            "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5Bootstrap.${i}.bak"
        ln -s -f "${TERMUX_PREFIX}/lib/libQt5Bootstrap.${i}" \
            "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5Bootstrap.${i}"
    done
    unset i
}

termux_step_configure () {
    "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
        -spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross" \
        LLVM_INSTALL_DIR="${TERMUX_PREFIX}"
}

termux_step_make() {
    make -j "${TERMUX_MAKE_PROCESSES}"
}

termux_step_make_install() {
    make install

    #######################################################
    ##
    ##  Compiling necessary programs for target.
    ##
    #######################################################

    ## Some top-level tools
    for i in makeqpf pixeltool qdoc qev qtattributionsscanner; do
        cd "${TERMUX_PKG_SRCDIR}/src/${i}" && {
            "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
                -spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross"

            make -j "${TERMUX_MAKE_PROCESSES}"
            install -Dm700 "../../bin/${i}" "${TERMUX_PREFIX}/bin/${i}"
        }
    done
    unset i

    # QDbusViewer desktop file (the binary would be installed already)
    install -D -m644 \
        "${TERMUX_PKG_SRCDIR}/src/qdbus/qdbusviewer/images/qdbusviewer.png" \
        "${TERMUX_PREFIX}/share/icons/hicolor/32x32/apps/qdbusviewer.png"
    install -D -m644 \
        "${TERMUX_PKG_SRCDIR}/src/qdbus/qdbusviewer/images/qdbusviewer-128.png" \
        "${TERMUX_PREFIX}/share/icons/hicolor/128x128/apps/qdbusviewer.png"
    install -D -m644 \
        "${TERMUX_PKG_BUILDER_DIR}/qdbusviewer.desktop" \
        "${TERMUX_PREFIX}/share/applications/qdbusviewer.desktop"

    # qdistancefieldgenerator (it has a different directory name but supports make install)
    cd "${TERMUX_PKG_SRCDIR}/src/distancefieldgenerator" && {
        "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
            -spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross"

        make -j "${TERMUX_MAKE_PROCESSES}"
        make install
    }

    #######################################################
    ##
    ##  Qt Linguist
    ##
    #######################################################

    ## Qt Linguist utilities
    for i in lconvert lrelease lupdate; do
        cd "${TERMUX_PKG_SRCDIR}/src/linguist/${i}" && {
            "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
                -spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross"

            make -j "${TERMUX_MAKE_PROCESSES}"
            install -Dm700 "../../../bin/${i}" "${TERMUX_PREFIX}/bin/${i}"
        }
    done

    ## Qt Linguist program
    cd "${TERMUX_PKG_SRCDIR}/src/linguist/linguist" && {
        "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
            -spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross"
        make -j "${TERMUX_MAKE_PROCESSES}"
        # There are more than just the binary to install
        make install
    }

    install -Dm644 \
        "${TERMUX_PKG_SRCDIR}/src/linguist/linguist/images/icons/linguist-32-32.png" \
        "${TERMUX_PREFIX}/share/icons/hicolor/32x32/apps/linguist.png"
    install -Dm644 \
        "${TERMUX_PKG_SRCDIR}/src/linguist/linguist/images/icons/linguist-128-32.png" \
        "${TERMUX_PREFIX}/share/icons/hicolor/128x128/apps/linguist.png"
    install -Dm644 \
        "${TERMUX_PKG_BUILDER_DIR}/linguist.desktop" \
        "${TERMUX_PREFIX}/share/applications/linguist.desktop"

    #######################################################
    ##
    ##  Qt Assistant
    ##
    #######################################################

    for i in qcollectiongenerator qhelpgenerator assistant; do
        cd "${TERMUX_PKG_SRCDIR}/src/assistant/${i}" && {
            "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
                -spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross"

            make -j "${TERMUX_MAKE_PROCESSES}"
            install -Dm700 "../../../bin/${i}" "${TERMUX_PREFIX}/bin/${i}"
        }
    done

    install -Dm644 \
        "${TERMUX_PKG_SRCDIR}/src/assistant/assistant/images/assistant.png" \
        "${TERMUX_PREFIX}/share/icons/hicolor/32x32/apps/assistant.png"
    install -Dm644 \
        "${TERMUX_PKG_SRCDIR}/src/assistant/assistant/images/assistant-128.png" \
        "${TERMUX_PREFIX}/share/icons/hicolor/128x128/apps/assistant.png"
    install -Dm644 \
        "${TERMUX_PKG_BUILDER_DIR}/assistant.desktop" \
        "${TERMUX_PREFIX}/share/applications/assistant.desktop"


    #######################################################
    ##
    ##  Qt Designer
    ##
    #######################################################

    for i in lib components designer plugins; do
        cd "${TERMUX_PKG_SRCDIR}/src/designer/src/${i}" && {
            "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
                -spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross"

            make -j "${TERMUX_MAKE_PROCESSES}"
            make install
        }
    done

    install -Dm644 \
        "${TERMUX_PKG_SRCDIR}/src/designer/src/designer/images/designer.png" \
        "${TERMUX_PREFIX}/share/icons/hicolor/128x128/apps/designer.png"
    install -Dm644 \
        "${TERMUX_PKG_BUILDER_DIR}/designer.desktop" \
        "${TERMUX_PREFIX}/share/applications/designer.desktop"


    #######################################################
    ##
    ##  Fixes & cleanup.
    ##
    #######################################################

    # Limit the scope, otherwise it'll touch qtbase files
    for pref in Designer Help UiTools UiPlugin; do
        ## Drop QMAKE_PRL_BUILD_DIR because reference the build dir.
        find "${TERMUX_PREFIX}/lib" -type f -name "libQt5${pref}*.prl" \
            -exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' "{}" \;
    done
    unset pref

    ## Remove *.la files.
    find "${TERMUX_PREFIX}/lib" -iname \*.la -delete
    find "${TERMUX_PREFIX}/opt/qt/cross/lib" -iname \*.la -delete


    #######################################################
    ##
    ##  Restore the bootstrap library
    ##
    #######################################################
    for i in a prl; do
        rm -f "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5Bootstrap.${i}"
        cp -p "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5Bootstrap.${i}.bak" \
            "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5Bootstrap.${i}"
        rm -f "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5Bootstrap.${i}.bak"
    done
    unset i
}

