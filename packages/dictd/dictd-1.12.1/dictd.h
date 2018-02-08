/* dictd.h -- Header file for dict program
 * Created: Fri Dec  2 20:01:18 1994 by faith@dict
 * Copyright 1994-2000, 2002 Rickard E. Faith (faith@dict.org)
 * Copyright 2002-2008 Aleksey Cheusov (vle@gmx.net)
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 1, or (at your option) any
 * later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */

#ifndef _DICTD_H_
#define _DICTD_H_

#include "dictP.h"
#include "maa.h"
#include "codes.h"
#include "defs.h"

#include "net.h"
#include <errno.h>

#include <netdb.h>
#include <signal.h>
/*
#ifdef __osf__
#define _XOPEN_SOURCE_EXTENDED
#endif
#include <sys/wait.h>
#include <grp.h>
#include <arpa/inet.h>
*/

extern const char *site_info;
extern int         site_info_no_banner;
extern int         site_info_no_uptime;
extern int         site_info_no_dblist;

extern const char *daemon_service;
extern int client_delay;
extern int depth;

extern int _dict_daemon_limit_childs;
extern int _dict_daemon_limit_childs_set;

extern int _dict_daemon_limit_matches;
extern int _dict_daemon_limit_defs;
extern int _dict_daemon_limit_time;
extern int _dict_daemon_limit_queries;
extern int _dict_markTime;
extern const char *logFile;
extern const char *pidFile;
extern int logOptions;
extern const char *bind_to;
extern int useSyslog;
extern const char *logFile;

extern int daemon_service_set;
extern int logFile_set;
extern int pidFile_set;
extern int _dict_markTime_set;
extern int client_delay_set;
extern int depth_set;
extern int syslog_facility_set;
extern int locale_set;
extern int default_strategy_set;
extern int bind_to_set;




extern void       dict_disable_strat (dictDatabase *db, const char* strat);

extern void       dict_dump_list( lst_List list );
extern void       dict_destroy_list( lst_List list );

extern int        dict_destroy_datum( const void *datum );

#ifdef USE_PLUGIN
extern int        dict_plugin_open (dictDatabase *db);
extern void       dict_plugin_close (dictDatabase *db);
#endif

/* dictd.c */

extern void set_minimal (void);

extern void       dict_initsetproctitle( int argc, char **argv, char **envp );
extern void       dict_setproctitle( const char *format, ... );
extern const char *dict_format_time( double t );
extern const char *dict_get_hostname( void );
extern const char *dict_get_banner( int shortFlag );

extern dictConfig *DictConfig;  /* GLOBAL VARIABLE */
extern int        _dict_comparisons; /* GLOBAL VARIABLE */
extern int        _dict_forks;	/* GLOBAL VARIABLE */
extern const char *locale;

extern const char *locale;
extern       int   inetd;    /* 1 if --inetd is applied, 0 otherwise */

/*
  If the filename doesn't start with / or .,
  it is prepended with DICT_DIR
*/
extern const char *postprocess_dict_filename (const char *fn);
/*
  If the filename doesn't start with / or .,
  it is prepended with PLUGIN_DIR
*/
extern const char *postprocess_plugin_filename (const char *fn);

/* daemon.c */

extern int  dict_daemon( int s, struct sockaddr_in *csin, int error );
extern int  dict_inetd( int error );
extern void daemon_terminate( int sig, const char *name );

/* */
extern int utf8_mode;
extern int stdin2stdout_mode;
				/* dmalloc must be last */
#ifdef DMALLOC_FUNC_CHECK
# include "dmalloc.h"
#endif

#endif
