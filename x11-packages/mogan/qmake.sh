#!/usr/bin/env bash

qmake_output=$(@TERMUX_PREFIX@/opt/qt6/cross/bin/qmake6 $@)

echo "${qmake_output}" | \
sed \
	-e "s|^QT_INSTALL_PREFIX:.*|QT_INSTALL_PREFIX:@TERMUX_PREFIX@|" \
	-e "s|^QT_INSTALL_ARCHDATA:.*|QT_INSTALL_ARCHDATA:@TERMUX_PREFIX@/lib/qt6|" \
	-e "s|^QT_INSTALL_DATA:.*|QT_INSTALL_DATA:@TERMUX_PREFIX@/share/qt6|" \
	-e "s|^QT_INSTALL_DOCS:.*|QT_INSTALL_DOCS:@TERMUX_PREFIX@/share/doc/qt6|" \
	-e "s|^QT_INSTALL_HEADERS:.*|QT_INSTALL_HEADERS:@TERMUX_PREFIX@/include/qt6|" \
	-e "s|^QT_INSTALL_LIBS:.*|QT_INSTALL_LIBS:@TERMUX_PREFIX@/lib|" \
	-e "s|^QT_INSTALL_BINS:.*|QT_INSTALL_BINS:@TERMUX_PREFIX@/opt/qt6/cross/bin|" \
	-e "s|^QT_INSTALL_TESTS:.*|QT_INSTALL_TESTS:@TERMUX_PREFIX@/tests|" \
	-e "s|^QT_INSTALL_QML:.*|QT_INSTALL_QML:@TERMUX_PREFIX@/lib/qt6/qml|" \
	-e "s|^QT_INSTALL_TRANSLATIONS:.*|QT_INSTALL_TRANSLATIONS:@TERMUX_PREFIX@/share/qt6/translations|" \
	-e "s|^QT_INSTALL_EXAMPLES:.*|QT_INSTALL_EXAMPLES:@TERMUX_PREFIX@/share/qt6/examples|" \
	-e "s|^QT_INSTALL_DEMOS:.*|QT_INSTALL_DEMOS:@TERMUX_PREFIX@/share/qt6/examples|"
