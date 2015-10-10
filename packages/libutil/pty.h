#ifndef _PTY_H
#define _PTY_H

#include <sys/cdefs.h>
#include <termios.h>

__BEGIN_DECLS

int openpty(int* amaster, int* aslave, char* name, struct termios* termp, struct winsize* winp);

int login_tty(int fd);

int forkpty(int* amaster, char* name, struct termios* termp, struct winsize* winp);

__END_DECLS

#endif
