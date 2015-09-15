#ifndef _PTY_H
#define _PTY_H

#include <termios.h>

int openpty(int* amaster, int* aslave, char* name, struct termios* termp, struct winsize* winp);

int login_tty(int fd);

int forkpty(int* amaster, char* name, struct termios* termp, struct winsize* winp);

#endif
