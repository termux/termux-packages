CXX ?= c++
CXXFLAGS := -I ../include/ -std=c++11 -fsanitize=address -g -O1 -fno-omit-frame-pointer

test: test_shared_ptr test_util_string

test_shared_ptr: build/test_shared_ptr
	@ASAN_OPTIONS="symbolize=1" build/test_shared_ptr

test_util_string: build/test_util_string
	@ASAN_OPTIONS="symbolize=1" build/test_util_string

build:
	@mkdir build

build/test_shared_ptr: test_shared_ptr.cpp ../src/memory/shared_ptr.cpp | build
	$(CXX) $(CXXFLAGS) ../src/memory/allocator.cpp ../src/memory/shared_ptr.cpp -o build/test_shared_ptr test_shared_ptr.cpp

build/test_util_string: test_util_string.cpp ../src/util_string.cpp | build
	$(CXX) $(CXXFLAGS) ../src/memory/allocator.cpp ../src/util_string.cpp -o build/test_util_string test_util_string.cpp

clean: | build
	rm -rf build

.PHONY: test test_shared_ptr test_util_string clean
