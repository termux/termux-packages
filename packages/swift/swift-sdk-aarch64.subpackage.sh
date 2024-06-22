TERMUX_SUBPKG_DESCRIPTION="Swift SDK for Android AArch64"
TERMUX_SUBPKG_INCLUDE="
lib/swift/android/aarch64/*.swiftdoc
lib/swift/android/aarch64/*.swiftmodule
lib/swift/android/aarch64/glibc.modulemap
lib/swift/android/aarch64/libswiftCxx.a
lib/swift/android/aarch64/SwiftGlibc.h
lib/swift/android/aarch64/swiftrt.o
lib/swift/android/*.swiftmodule/aarch64-*
lib/swift_static/android/aarch64/
lib/swift_static/android/*.swiftmodule/aarch64-*
"
TERMUX_SUBPKG_PLATFORM_INDEPENDENT=true
TERMUX_SUBPKG_DEPENDS="swift-runtime-aarch64"
TERMUX_SUBPKG_BREAKS="swift (<< 5.8)"
TERMUX_SUBPKG_REPLACES="swift (<< 5.8)"
