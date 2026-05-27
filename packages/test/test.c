#include <stdio.h>
int main() {
	printf("test program running\n");
#ifdef __ANDROID__
	printf("android flag detected\n");
#endif
#ifdef __BIONIC__
	printf("bionic flag detected\n");
#endif
#ifdef __GLIBC__
	printf("glibc flag detected\n");
#endif
#ifdef __TERMUX__
	printf("termux flag detected\n");
#endif
	return 0;
}