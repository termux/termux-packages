#include <stdio.h>
#include <stdlib.h>
#include <sys/system_properties.h>

int __android_log_vprint(int prio, const char* tag, const char* fmt, va_list ap) {
    char buf[1024];
    vsnprintf(buf, sizeof(buf), fmt, ap);
    fprintf(stdout, "%s: %s\n", tag, buf);
    return 0;
}

void* dlopen(const char* filename, int flag) {
    return (void*)1;
}

void* dlsym(void* handle, const char* symbol) {
	// https://github.com/golang/go/issues/59942
	if (strcmp(symbol, "android_get_device_api_level") != 0) {
		fprintf(stderr, "Error: Unexpected symbol requested: %s\n", symbol);
		exit(1);
	}
	char buff[PROP_VALUE_MAX];
	int n = __system_property_get("ro.build.version.sdk", buff);
	if (n <= 0) {
		fprintf(stderr, "Error: Failed to get device API level\n");
		exit(1);
	}
	int api_level = atoi(buff);
	if (api_level < 29) {
		return NULL;
	}
	return (void*)1;
}

int dlclose(void* handle) {
    return 0;
}