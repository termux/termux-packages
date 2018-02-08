#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/termios.h>
#include <fcntl.h>

#include "dictd.h"

int daemon (int nochdir, int noclose)
{
   int i;
   int fd;

   switch (fork()) {
   case -1: err_fatal_errno( __func__, "Cannot fork\n" ); break;
   case 0:  break;		/* child */
   default: exit(0);		/* parent */
   }
   
   /* The detach algorithm is a modification of that presented by Comer,
      Douglas E. and Stevens, David L. INTERNETWORKING WITH TCP/IP, VOLUME
      III: CLIENT-SERVER PROGRAMMING AND APPLICATIONS (BSD SOCKET VERSION).
      Englewood Cliffs, New Jersey: Prentice Hall, 1993 (Chapter 27). */

   if (!noclose)
      for (i=getdtablesize()-1; i >= 0; --i)
	 close(i); /* close everything */

#if defined(__hpux__) || defined(__CYGWIN__) || defined(__INTERIX) || defined(__OPENNT)
#ifndef TIOCNOTTY
#define NO_IOCTL_TIOCNOTTY
#endif /* TIOCNOTTY */
#endif /* strange platforms */

#ifndef NO_IOCTL_TIOCNOTTY
   if ((fd = open("/dev/tty", O_RDWR)) >= 0) {
				/* detach from controlling tty */
      ioctl(fd, TIOCNOTTY, 0);
      close(fd);
   }
#endif

   if (!nochdir)
      chdir("/");		/* cd to safe directory */

   setpgid(0,getpid());	/* Get process group */

   if (!noclose){
      fd = open("/dev/null", O_RDWR);    /* stdin */
      dup(fd);			      /* stdout */
      dup(fd);			      /* stderr */
   }
}
