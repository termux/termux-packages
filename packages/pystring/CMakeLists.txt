project(pystring
	LANGUAGES CXX
	)

cmake_minimum_required(VERSION 3.0)

set(CMAKE_CXX_FLAGS "-O3 -Wall -Wextra -Wshadow -Wconversion -Wcast-qual -Wformat=2 ${CMAKE_CXX_FLAGS}")

include(GNUInstallDirs)
mark_as_advanced(CLEAR CMAKE_INSTALL_LIBDIR
                       CMAKE_INSTALL_INCLUDEDIR
					   )

add_library(pystring SHARED
    pystring.cpp
	)

set_target_properties(pystring PROPERTIES 
    SOVERSION 0.0
	)

install(TARGETS pystring
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
	)

install(FILES pystring.h
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/pystring
	)

add_executable(test pystring.cpp test.cpp)
target_compile_definitions(test PRIVATE PYSTRING_UNITTEST=1)
