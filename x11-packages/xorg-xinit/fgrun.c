/* Joins the terminal's current foreground process group before exec, so a
 * client xinit detached into its own group (e.g. dialog(1)) can read the tty. */

#include <stdio.h>
#include <unistd.h>

static const char help[] =
"usage: fgrun COMMAND [ARG]...\n"
"\n"
"xinit puts its client in a process group of its own, detached from the\n"
"terminal's foreground group - fine for an X client talking over the X\n"
"protocol, but a client that needs to read the terminal (e.g. dialog(1))\n"
"gets EIO instead. fgrun joins the terminal's current foreground group\n"
"(setpgid, no special privilege needed, unlike tcsetpgrp which reassigns\n"
"it) before exec'ing COMMAND, and exits with it - nothing to restore.\n";

int main(int argc, char **argv) {
    if (argc < 2) {
        fputs(help, stderr);
        return 2;
    }

    pid_t fg = tcgetpgrp(0);
    if (fg >= 0)
        setpgid(0, fg);

    execvp(argv[1], &argv[1]);
    perror(argv[1]);
    return 127;
}
