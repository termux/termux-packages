TERMUX_SUBPKG_INCLUDE="
lib/jvm/java-19-openjdk/include/jawt.h
lib/jvm/java-19-openjdk/include/linux/jawt_md.h
lib/jvm/java-19-openjdk/jmods/java.desktop.jmod
lib/jvm/java-19-openjdk/lib/libawt_xawt.so
lib/jvm/java-19-openjdk/lib/libfontmanager.so
lib/jvm/java-19-openjdk/lib/libjawt.so
lib/jvm/java-19-openjdk/lib/libsplashscreen.so
"
TERMUX_SUBPKG_DESCRIPTION="Portion of openjdk-19 requiring X11 functionality"
TERMUX_SUBPKG_DEPENDS="fontconfig, freetype, giflib, libandroid-shmem, libpng, libx11, libxext, libxi, libxrandr, libxrender, libxt, libxtst"
