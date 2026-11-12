cmake_minimum_required(VERSION 3.29)
project(termux-wsi-layer C)

set(CMAKE_BUILD_TYPE Debug)
set(CMAKE_C_STANDARD 11)
find_package(PkgConfig REQUIRED)
pkg_check_modules(X11 REQUIRED x11 x11-xcb xcb xcb-dri3 xcb-present)

add_library(termux-wsi-layer SHARED egl.c)
set_target_properties(termux-wsi-layer PROPERTIES PREFIX "")
target_compile_options(termux-wsi-layer PRIVATE ${X11_CFLAGS})
target_link_options(termux-wsi-layer PRIVATE -Wl,--no-as-needed -landroid -Wl,--as-needed -ggdb ${X11_LDFLAGS})

install(TARGETS termux-wsi-layer LIBRARY DESTINATION lib ARCHIVE DESTINATION lib)
install(FILES 10_termux.json DESTINATION ${CMAKE_INSTALL_PREFIX}/share/glvnd/egl_vendor.d)
add_custom_target(uninstall)
add_custom_command(TARGET uninstall POST_BUILD COMMAND rm ARGS -v -f
    ${CMAKE_INSTALL_PREFIX}/share/glvnd/egl_vendor.d/10_termux.json
    ${CMAKE_INSTALL_PREFIX}/lib/termux-wsi-layer.so
)
