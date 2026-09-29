/*	$NetBSD: getpass.c,v 1.15 2003/08/07 16:42:50 agc Exp $	*/
/*
 * Copyright (c) 1988, 1993
 *	The Regents of the University of California.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */
#if 0
#include <sys/cdefs.h>
#if defined(LIBC_SCCS) && !defined(lint)
#if 0
static char sccsid[] = "@(#)getpass.c	8.1 (Berkeley) 6/4/93";
#else
__RCSID("$NetBSD: getpass.c,v 1.15 2003/08/07 16:42:50 agc Exp $");
#endif
#endif /* LIBC_SCCS and not lint */
#include "namespace.h"
#endif
#include <assert.h>
#include <paths.h>
#include <pwd.h>
#include <signal.h>
#include <stdio.h>
#include <termios.h>
#include <unistd.h>
#if 0
#ifdef __weak_alias
__weak_alias(getpass,_getpass)
#endif
#endif
char *
getpass(prompt)
	const char *prompt;
{
	struct termios term;
	int ch;
	char *p;
	FILE *fp, *outfp;
	int echo;
	static char buf[_PASSWORD_LEN + 1];
	sigset_t oset, nset;
#if 0
	_DIAGASSERT(prompt != NULL);
#endif
	/*
	 * read and write to /dev/tty if possible; else read from
	 * stdin and write to stderr.
	 */
	if ((outfp = fp = fopen(_PATH_TTY, "w+")) == NULL) {
		outfp = stderr;
		fp = stdin;
	}
	/*
	 * note - blocking signals isn't necessarily the
	 * right thing, but we leave it for now.
	 */
	sigemptyset(&nset);
	sigaddset(&nset, SIGINT);
	sigaddset(&nset, SIGTSTP);
	(void)sigprocmask(SIG_BLOCK, &nset, &oset);
	(void)tcgetattr(fileno(fp), &term);
	if ((echo = (term.c_lflag & ECHO)) != 0) {
		term.c_lflag &= ~ECHO;
		(void)tcsetattr(fileno(fp), TCSAFLUSH /*|TCSASOFT*/, &term);
	}
	if (prompt != NULL)
		(void)fputs(prompt, outfp);
	rewind(outfp);			/* implied flush */
	for (p = buf; (ch = getc(fp)) != EOF && ch != '\n';)
		if (p < buf + _PASSWORD_LEN)
			*p++ = ch;
	*p = '\0';
	(void)write(fileno(outfp), "\n", 1);
	if (echo) {
		term.c_lflag |= ECHO;
		(void)tcsetattr(fileno(fp), TCSAFLUSH/*|TCSASOFT*/, &term);
	}
	(void)sigprocmask(SIG_SETMASK, &oset, NULL);
	if (fp != stdin)
		(void)fclose(fp);
	return(buf);
}
