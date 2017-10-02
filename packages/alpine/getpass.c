/* Copyright (C) 1992-2001, 2003-2007, 2009-2016 Free Software Foundation, Inc.

   This file is part of the GNU C Library.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along
   with this program; if not, see <http://www.gnu.org/licenses/>.  */

/*#ifndef _LIBC
# include <config.h>
#endifi*/

#include "getpass.h"


#include <stdio.h>

#if !((defined _WIN32 || defined __WIN32__) && !defined __CYGWIN__)

# include <stdbool.h>

# if HAVE_DECL___FSETLOCKING && HAVE___FSETLOCKING
#  if HAVE_STDIO_EXT_H
#   include <stdio_ext.h>
#  endif
# else
#  define __fsetlocking(stream, type)    /* empty */
# endif

# if HAVE_TERMIOS_H
#  include <termios.h>
# endif

# if USE_UNLOCKED_IO
#  include "unlocked-io.h"
# else
#  if !HAVE_DECL_FFLUSH_UNLOCKED
#   undef fflush_unlocked
#   define fflush_unlocked(x) fflush (x)
#  endif
#  if !HAVE_DECL_FLOCKFILE
#   undef flockfile
#   define flockfile(x) ((void) 0)
#  endif
#  if !HAVE_DECL_FUNLOCKFILE
#   undef funlockfile
#   define funlockfile(x) ((void) 0)
#  endif
#  if !HAVE_DECL_FPUTS_UNLOCKED
#   undef fputs_unlocked
#   define fputs_unlocked(str,stream) fputs (str, stream)
#  endif
#  if !HAVE_DECL_PUTC_UNLOCKED
#   undef putc_unlocked
#   define putc_unlocked(c,stream) putc (c, stream)
#  endif
# endif

/* It is desirable to use this bit on systems that have it.
   The only bit of terminal state we want to twiddle is echoing, which is
   done in software; there is no need to change the state of the terminal
   hardware.  */

# ifndef TCSASOFT
#  define TCSASOFT 0
# endif

static void
call_fclose (void *arg)
{
  if (arg != NULL)
    fclose (arg);
}

char *
getpass (const char *prompt)
{
  FILE *tty;
  FILE *in, *out;
# if HAVE_TCGETATTR
  struct termios s, t;
# endif
  bool tty_changed = false;
  static char *buf;
  static size_t bufsize;
  ssize_t nread;

  /* Try to write to and read from the terminal if we can.
     If we can't open the terminal, use stderr and stdin.  */

  tty = fopen ("/dev/tty", "w+");
  if (tty == NULL)
    {
      in = stdin;
      out = stderr;
    }
  else
    {
      /* We do the locking ourselves.  */
      __fsetlocking (tty, FSETLOCKING_BYCALLER);

      out = in = tty;
    }

  flockfile (out);

  /* Turn echoing off if it is on now.  */
# if HAVE_TCGETATTR
  if (tcgetattr (fileno (in), &t) == 0)
    {
      /* Save the old one. */
      s = t;
      /* Tricky, tricky. */
      t.c_lflag &= ~(ECHO | ISIG);
      tty_changed = (tcsetattr (fileno (in), TCSAFLUSH | TCSASOFT, &t) == 0);
    }
# endif

  /* Write the prompt.  */
  fputs_unlocked (prompt, out);
  fflush_unlocked (out);

  /* Read the password.  */
  nread = getline (&buf, &bufsize, in);

  /* According to the C standard, input may not be followed by output
     on the same stream without an intervening call to a file
     positioning function.  Suppose in == out; then without this fseek
     call, on Solaris, HP-UX, AIX, OSF/1, the previous input gets
     echoed, whereas on IRIX, the following newline is not output as
     it should be.  POSIX imposes similar restrictions if fileno (in)
     == fileno (out).  The POSIX restrictions are tricky and change
     from POSIX version to POSIX version, so play it safe and invoke
     fseek even if in != out.  */
  fseeko (out, 0, SEEK_CUR);

  if (buf != NULL)
    {
      if (nread < 0)
        buf[0] = '\0';
      else if (buf[nread - 1] == '\n')
        {
          /* Remove the newline.  */
          buf[nread - 1] = '\0';
          if (tty_changed)
            {
              /* Write the newline that was not echoed.  */
              putc_unlocked ('\n', out);
            }
        }
    }

  /* Restore the original setting.  */
# if HAVE_TCSETATTR
  if (tty_changed)
    tcsetattr (fileno (in), TCSAFLUSH | TCSASOFT, &s);
# endif

  funlockfile (out);

  call_fclose (tty);

  return buf;
}

#else /* W32 native */

/* Windows implementation by Martin Lambers <marlam@marlam.de>,
   improved by Simon Josefsson. */

/* For PASS_MAX. */
# include <limits.h>
/* For _getch(). */
# include <conio.h>
/* For strdup(). */
# include <string.h>

# ifndef PASS_MAX
#  define PASS_MAX 512
# endif

char *
getpass (const char *prompt)
{
  char getpassbuf[PASS_MAX + 1];
  size_t i = 0;
  int c;

  if (prompt)
    {
      fputs (prompt, stderr);
      fflush (stderr);
    }

  for (;;)
    {
      c = _getch ();
      if (c == '\r')
        {
          getpassbuf[i] = '\0';
          break;
        }
      else if (i < PASS_MAX)
        {
          getpassbuf[i++] = c;
        }

      if (i >= PASS_MAX)
        {
          getpassbuf[i] = '\0';
          break;
        }
    }

  if (prompt)
    {
      fputs ("\r\n", stderr);
      fflush (stderr);
    }

  return strdup (getpassbuf);
}
#endif
