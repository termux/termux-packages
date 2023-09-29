TERMUX_SUBPKG_DESCRIPTION="Swift SDK for Android armv7"
TERMUX_SUBPKG_INCLUDE="
lib/swift/android/armv7/*.swiftdoc
lib/swift/android/armv7/*.swiftmodule
lib/swift/android/armv7/glibc.modulemap
lib/swift/android/armv7/libswiftCxx.a
lib/swift/android/armv7/SwiftGlibc.h
lib/swift/android/armv7/swiftrt.o
lib/swift/android/*.swiftmodule/armv7-*
lib/swift_static/android/armv7/
lib/swift_static/android/*.swiftmodule/armv7-*
"
TERMUX_SUBPKG_PLATFORM_INDEPENDENT=true
TERMUX_SUBPKG_DEPENDS="swift-runtime-arm"
TERMUX_SUBPKG_BREAKS="swift (<< 5.8)"
TERMUX_SUBPKG_REPLACES="swift (<< 5.8)"
