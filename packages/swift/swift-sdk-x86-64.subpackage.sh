TERMUX_SUBPKG_DESCRIPTION="Swift SDK for Android x86_64"
TERMUX_SUBPKG_INCLUDE="
lib/swift/android/x86_64/*.swiftdoc
lib/swift/android/x86_64/*.swiftmodule
lib/swift/android/x86_64/glibc.modulemap
lib/swift/android/x86_64/libswiftCxx.a
lib/swift/android/x86_64/SwiftGlibc.h
lib/swift/android/x86_64/swiftrt.o
lib/swift/android/*.swiftmodule/x86_64-*
lib/swift_static/android/x86_64/
lib/swift_static/android/*.swiftmodule/x86_64-*
"
TERMUX_SUBPKG_PLATFORM_INDEPENDENT=true
TERMUX_SUBPKG_DEPENDS="swift-runtime-x86-64"
TERMUX_SUBPKG_BREAKS="swift (<< 5.8)"
TERMUX_SUBPKG_REPLACES="swift (<< 5.8)"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
