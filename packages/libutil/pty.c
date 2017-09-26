#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/param.h>
#include <sys/types.h>
#include <stdlib.h>
#include <termios.h>
#include <unistd.h>


int openpty(int* amaster, int* aslave, char* name, const struct termios* termp, const struct winsize* winp)
{
	char buf[512];

	int master = open("/dev/ptmx", O_RDWR);
	if (master == -1) return -1;
	if (grantpt(master) || unlockpt(master) || ptsname_r(master, buf, sizeof buf)) goto fail;

	int slave = open(buf, O_RDWR | O_NOCTTY);
	if (slave == -1) goto fail;

	/* XXX Should we ignore errors here?  */
	if (termp) tcsetattr(slave, TCSAFLUSH, termp);
	if (winp) ioctl(slave, TIOCSWINSZ, winp);

	*amaster = master;
	*aslave = slave;
	if (name != NULL) strcpy(name, buf);
	return 0;

fail:
	close(master);
	return -1;
}


int login_tty(int fd)
{
	setsid();
	if (ioctl(fd, TIOCSCTTY, NULL) == -1) return -1;
	dup2(fd, 0);
	dup2(fd, 1);
	dup2(fd, 2);
	if (fd > 2) close(fd);
	return 0;
}


int forkpty(int* amaster, char* name, const struct termios* termp, const struct winsize* winp)
{
	int master, slave;
	if (openpty(&master, &slave, name, termp, winp) == -1) {
		return -1;
	}

	int pid;
	switch (pid = fork()) {
		case -1:
			return -1;
		case 0:
			close(master);
			if (login_tty(slave)) _exit(1);
			return 0;
		default:
			*amaster = master;
			close (slave);
			return pid;
	}
}
