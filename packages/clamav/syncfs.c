#if defined __ANDROID__ && __ANDROID_API__ < 28
#include <sys/syscall.h>
#include <unistd.h>

int
syncfs(int fd)
{
    return syscall(SYS_syncfs, fd);
}
#endif
