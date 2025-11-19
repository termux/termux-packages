#ifndef _LIBINTL_H
#define _LIBINTL_H

#include <errno.h>
#include <string.h>

static __inline__ char* gettext(const char* msgid)
{ return (char*) msgid; }

static __inline__ char* dgettext(const char* domainname, const char* msgid)
{ return (char*) msgid; }

static __inline__ char* dcgettext(const char* domainname, const char* msgid, int category)
{ return (char*) msgid; }

static __inline__ char* ngettext(const char* msgid1, const char* msgid2, unsigned long int n)
{ return (char *) ((n == 1) ? msgid1 : msgid2); }

static __inline__ char* dngettext(const char* domainname, const char* msgid1, const char* msgid2, unsigned long int n)
{ return (char *) ((n == 1) ? msgid1 : msgid2); }

static __inline__ char* dcngettext(const char* domainname, const char* msgid1, const char* msgid2, unsigned long int n, int category)
{ return (char *) ((n == 1) ? msgid1 : msgid2); }

static __inline__ char* textdomain(const char* domainname)
{
	static const char default_str[] = "messages";
	if (domainname && *domainname && strcmp(domainname, default_str)) {
		errno = EINVAL;
		return NULL;
	}
	return (char*) default_str;
}

static __inline__ char* bindtextdomain(const char* domainname, const char* dirname)
{
	static const char dir[] = "/";
	if (!domainname || !*domainname || (dirname && ((dirname[0] != '/') || dirname[1]))) {
		errno = EINVAL;
		return NULL;
	}
	return (char*) dir;
}

static __inline__ char* bind_textdomain_codeset(const char* domainname, const char* codeset)
{
	if (!domainname || !*domainname || (codeset && strcasecmp(codeset, "UTF-8"))) {
		errno = EINVAL;
	}
	return NULL;
}

#endif
