#include <complex.h>
#include <math.h>

// https://git.musl-libc.org/cgit/musl/tree/src/complex/clogf.c

// Fix for

// ld.lld: error: undefined reference due to --no-allow-shlib-undefined: clogf
// >>> referenced by liboctave/.libs/liboctave.so
// clang++: error: linker command failed with exit code 1 (use -v to see invocation)

// This symbol appeared in API 29 so we should define it as weak to avoid interference with system version

float complex __attribute__((weak)) clogf(float complex z) {
	float r, phi;

	r = cabsf(z);
	phi = cargf(z);
	return CMPLXF(logf(r), phi);
};
