TERMUX_SUBPKG_INCLUDE="
lib/jvm/java-21-openjdk/include/jawt.h
lib/jvm/java-21-openjdk/include/linux/jawt_md.h
lib/jvm/java-21-openjdk/jmods/java.desktop.jmod
lib/jvm/java-21-openjdk/lib/libawt_xawt.so
lib/jvm/java-21-openjdk/lib/libfontmanager.so
lib/jvm/java-21-openjdk/lib/libjawt.so
lib/jvm/java-21-openjdk/lib/libsplashscreen.so
"
TERMUX_SUBPKG_DESCRIPTION="Portion of openjdk-21 requiring X11 functionality"
TERMUX_SUBPKG_DEPENDS="freetype, giflib, libandroid-shmem, libjpeg-turbo, libpng, libx11, libxext, libxi, libxrender, libxtst"
