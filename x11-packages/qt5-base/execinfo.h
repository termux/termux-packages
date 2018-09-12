#ifndef FAKE_EXECINFO_H
#define FAKE_EXECINFO_H
int backtrace(void **array, int size) { return 0; }
char **backtrace_symbols(void *const *array, int size) { return 0; }
void backtrace_symbols_fd (void *const *array, int size, int fd) {}
#endif
