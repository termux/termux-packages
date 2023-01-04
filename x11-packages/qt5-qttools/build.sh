TERMUX_PKG_HOMEPAGE=https://www.qt.io/
TERMUX_PKG_DESCRIPTION="Qt Development Tools (Linguist, Assistant, Designer, etc.)"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="Simeon Huang <symeon@librehat.com>"
TERMUX_PKG_VERSION=5.15.8
TERMUX_PKG_SRCURL="https://download.qt.io/official_releases/qt/5.15/${TERMUX_PKG_VERSION}/submodules/qttools-everywhere-opensource-src-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=a3bef8de13032dae17450f5df35e8abbb4f41f71e3b628871d3da5633577e9c4
TERMUX_PKG_DEPENDS="libc++, qt5-qtbase, qt5-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qtdeclarative-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true

# Ignore the bootstrap library that is touched by the hijack
TERMUX_PKG_RM_AFTER_INSTALL="
opt/qt/cross/lib/libQt5Bootstrap.*
opt/qt/cross/lib/libQt5QmlDevTools.*
"

# Replacing the old qt5-base packages
TERMUX_PKG_REPLACES="qt5-tools"

termux_step_pre_configure () {
    #######################################################
    ##
    ##  Hijack the bootstrap library
    ##
    #######################################################
    for i in Bootstrap QmlDevTools; do
        cp -p "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5${i}.a" \
            "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5${i}.a.bak"
        ln -s -f "${TERMUX_PREFIX}/lib/libQt5${i}.a" \
            "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5${i}.a"
        cp -p "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5${i}.prl" \
            "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5${i}.prl.bak"
        ln -s -f "${TERMUX_PREFIX}/lib/libQt5${i}.prl" \
            "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5${i}.prl"
    done
    unset i
}

termux_step_configure () {
    "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
        -spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross"
}

termux_step_post_make_install() {
    #######################################################
    ##
    ##  Compiling necessary programs for target.
    ##
    #######################################################

    ## Some top-level tools
    # FIXME: qdoc cannot be built at the moment because qmake couldn't find libclang when built with -I
    for i in makeqpf pixeltool qev qtattributionsscanner; do
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

    # Install the linguist utilities to the correct path
    for i in lconvert lprodump lrelease{,-pro} lupdate{,-pro}; do
        install -Dm700 "${TERMUX_PKG_SRCDIR}/bin/${i}" "${TERMUX_PREFIX}/bin/${i}"
    done

    # Build and install linguist program
    cd "${TERMUX_PKG_SRCDIR}/src/linguist/linguist" && {
        "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
            -spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross"
        make -j "${TERMUX_MAKE_PROCESSES}"
        make install
    }

    # Install the linguist desktop file
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
    ##  Restore the bootstrap library
    ##
    #######################################################
    for i in Bootstrap QmlDevTools; do
        mv "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5${i}.a.bak" \
            "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5${i}.a"
        mv "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5${i}.prl.bak" \
            "${TERMUX_PREFIX}/opt/qt/cross/lib/libQt5${i}.prl"
    done


    #######################################################
    ##
    ##  Compiling necessary programs for host
    ##
    #######################################################

    # These programs were built and linked for the target
    # We need to build them again but for the host
    cd "${TERMUX_PKG_SRCDIR}/src/qtattributionsscanner" && {
        make clean
        "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
            -spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-host"
        make -j "${TERMUX_MAKE_PROCESSES}"
        install -Dm700 \
            "../../bin/qtattributionsscanner" \
            "${TERMUX_PREFIX}/opt/qt/cross/bin/qtattributionsscanner"
    }

    for i in lconvert lprodump lrelease{,-pro} lupdate{,-pro}; do
        cd "${TERMUX_PKG_SRCDIR}/src/linguist/${i}" && {
            make clean
            "${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
                -spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-host"
            make -j "${TERMUX_MAKE_PROCESSES}"
            install -Dm700 "../../../bin/${i}" "${TERMUX_PREFIX}/opt/qt/cross/bin/${i}"
        }
    done

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
}

termux_step_create_debscripts() {
    # Some clean-up is happening via `postinst`
    # Because we're using this package in both host (Ubuntu glibc) and device (Termux)
    cp -f "${TERMUX_PKG_BUILDER_DIR}/postinst" ./
    sed -i "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" ./postinst
}
