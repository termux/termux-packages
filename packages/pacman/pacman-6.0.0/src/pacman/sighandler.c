/*
 *  sighandler.c
 *
 *  Copyright (c) 2015-2021 Pacman Development Team <pacman-dev@archlinux.org>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <errno.h>
#include <signal.h>
#include <unistd.h>

#include <alpm.h>

#include "conf.h"
#include "sighandler.h"
#include "util.h"

/** Write function that correctly handles EINTR.
 */
static ssize_t xwrite(int fd, const void *buf, size_t count)
{
	ssize_t ret;
	do {
		ret = write(fd, buf, count);
	} while(ret == -1 && errno == EINTR);
	return ret;
}

static void _reset_handler(int signum)
{
	struct sigaction new_action;
	sigemptyset(&new_action.sa_mask);
	new_action.sa_handler = SIG_DFL;
	new_action.sa_flags = 0;
	sigaction(signum, &new_action, NULL);
}

/** Catches thrown signals. Performs necessary cleanup to ensure database is
 * in a consistent state.
 * @param signum the thrown signal
 */
static void soft_interrupt_handler(int signum)
{
	console_cursor_move_end();

	if(signum == SIGINT) {
		const char msg[] = "\nInterrupt signal received\n";
		xwrite(STDERR_FILENO, msg, ARRAYSIZE(msg) - 1);
	} else {
		const char msg[] = "\nHangup signal received\n";
		xwrite(STDERR_FILENO, msg, ARRAYSIZE(msg) - 1);
	}
	xwrite(STDOUT_FILENO, CURSOR_SHOW_ANSICODE,
		sizeof(CURSOR_SHOW_ANSICODE) - 1);
	if(alpm_trans_interrupt(config->handle) == 0) {
		/* a transaction is being interrupted, don't exit pacman yet. */
		return;
	}
	alpm_unlock(config->handle);
	/* output a newline to be sure we clear any line we may be on */
	xwrite(STDOUT_FILENO, "\n", 1);
	_Exit(128 + signum);
}

void install_soft_interrupt_handler(void)
{
	struct sigaction new_action;
	new_action.sa_handler = soft_interrupt_handler;
	new_action.sa_flags = SA_RESTART;
	sigemptyset(&new_action.sa_mask);
	sigaddset(&new_action.sa_mask, SIGINT);
	sigaddset(&new_action.sa_mask, SIGHUP);

	sigaction(SIGINT, &new_action, NULL);
	sigaction(SIGHUP, &new_action, NULL);
}

void remove_soft_interrupt_handler(void)
{
	_reset_handler(SIGINT);
	_reset_handler(SIGHUP);
}

static void segv_handler(int signum)
{
	sigset_t segvset;
	const char msg[] = "\nerror: segmentation fault\n"
		"Please submit a full bug report with --debug if appropriate.\n";
	console_cursor_move_end();
	xwrite(STDERR_FILENO, msg, sizeof(msg) - 1);
	xwrite(STDOUT_FILENO, CURSOR_SHOW_ANSICODE,
		sizeof(CURSOR_SHOW_ANSICODE) - 1);

	/* restore the default handler */
	_reset_handler(signum);
	/* unblock SIGSEGV */
	sigemptyset(&segvset);
	sigaddset(&segvset, signum);
	sigprocmask(SIG_UNBLOCK, &segvset, NULL);
	/* re-raise to trigger a core dump */
	raise(signum);

	/* raise should immediately abort, but just to make absolutely sure */
	_Exit(signum);
}

void install_segv_handler(void)
{
	struct sigaction new_action;
	new_action.sa_handler = segv_handler;
	sigfillset(&new_action.sa_mask);
	new_action.sa_flags = SA_RESTART;
	sigaction(SIGSEGV, &new_action, NULL);
}

static void winch_handler(int signum)
{
	(void)signum; /* suppress unused variable warnings */
	columns_cache_reset();
}

void install_winch_handler(void)
{
	struct sigaction new_action;
	new_action.sa_handler = winch_handler;
	sigemptyset(&new_action.sa_mask);
	new_action.sa_flags = SA_RESTART;
	sigaction(SIGWINCH, &new_action, NULL);
}
