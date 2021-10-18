/*
 *  Copyright (c) 2006-2021 Pacman Development Team <pacman-dev@archlinux.org>
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

#include <string.h>
#include <ctype.h>

/* libalpm */
#include "util.h"

/**
 * Some functions in this file have been adopted from the rpm source, notably
 * 'rpmvercmp' located at lib/rpmvercmp.c and 'parseEVR' located at
 * lib/rpmds.c. It was most recently updated against rpm version 4.8.1. Small
 * modifications have been made to make it more consistent with the libalpm
 * coding style.
 */

/**
 * Split EVR into epoch, version, and release components.
 * @param evr		[epoch:]version[-release] string
 * @retval *ep		pointer to epoch
 * @retval *vp		pointer to version
 * @retval *rp		pointer to release
 */
static void parseEVR(char *evr, const char **ep, const char **vp,
		const char **rp)
{
	const char *epoch;
	const char *version;
	const char *release;
	char *s, *se;

	s = evr;
	/* s points to epoch terminator */
	while (*s && isdigit(*s)) s++;
	/* se points to version terminator */
	se = strrchr(s, '-');

	if(*s == ':') {
		epoch = evr;
		*s++ = '\0';
		version = s;
		if(*epoch == '\0') {
			epoch = "0";
		}
	} else {
		/* different from RPM- always assume 0 epoch */
		epoch = "0";
		version = evr;
	}
	if(se) {
		*se++ = '\0';
		release = se;
	} else {
		release = NULL;
	}

	if(ep) *ep = epoch;
	if(vp) *vp = version;
	if(rp) *rp = release;
}

/**
 * Compare alpha and numeric segments of two versions.
 * return 1: a is newer than b
 *        0: a and b are the same version
 *       -1: b is newer than a
 */
static int rpmvercmp(const char *a, const char *b)
{
	char oldch1, oldch2;
	char *str1, *str2;
	char *ptr1, *ptr2;
	char *one, *two;
	int rc;
	int isnum;
	int ret = 0;

	/* easy comparison to see if versions are identical */
	if(strcmp(a, b) == 0) return 0;

	str1 = strdup(a);
	str2 = strdup(b);

	one = ptr1 = str1;
	two = ptr2 = str2;

	/* loop through each version segment of str1 and str2 and compare them */
	while (*one && *two) {
		while (*one && !isalnum((int)*one)) one++;
		while (*two && !isalnum((int)*two)) two++;

		/* If we ran to the end of either, we are finished with the loop */
		if (!(*one && *two)) break;

		/* If the separator lengths were different, we are also finished */
		if ((one - ptr1) != (two - ptr2)) {
			ret = (one - ptr1) < (two - ptr2) ? -1 : 1;
			goto cleanup;
		}

		ptr1 = one;
		ptr2 = two;

		/* grab first completely alpha or completely numeric segment */
		/* leave one and two pointing to the start of the alpha or numeric */
		/* segment and walk ptr1 and ptr2 to end of segment */
		if (isdigit((int)*ptr1)) {
			while (*ptr1 && isdigit((int)*ptr1)) ptr1++;
			while (*ptr2 && isdigit((int)*ptr2)) ptr2++;
			isnum = 1;
		} else {
			while (*ptr1 && isalpha((int)*ptr1)) ptr1++;
			while (*ptr2 && isalpha((int)*ptr2)) ptr2++;
			isnum = 0;
		}

		/* save character at the end of the alpha or numeric segment */
		/* so that they can be restored after the comparison */
		oldch1 = *ptr1;
		*ptr1 = '\0';
		oldch2 = *ptr2;
		*ptr2 = '\0';

		/* this cannot happen, as we previously tested to make sure that */
		/* the first string has a non-null segment */
		if (one == ptr1) {
			ret = -1;	/* arbitrary */
			goto cleanup;
		}

		/* take care of the case where the two version segments are */
		/* different types: one numeric, the other alpha (i.e. empty) */
		/* numeric segments are always newer than alpha segments */
		/* XXX See patch #60884 (and details) from bugzilla #50977. */
		if (two == ptr2) {
			ret = isnum ? 1 : -1;
			goto cleanup;
		}

		if (isnum) {
			/* this used to be done by converting the digit segments */
			/* to ints using atoi() - it's changed because long  */
			/* digit segments can overflow an int - this should fix that. */

			/* throw away any leading zeros - it's a number, right? */
			while (*one == '0') one++;
			while (*two == '0') two++;

			/* whichever number has more digits wins */
			if (strlen(one) > strlen(two)) {
				ret = 1;
				goto cleanup;
			}
			if (strlen(two) > strlen(one)) {
				ret = -1;
				goto cleanup;
			}
		}

		/* strcmp will return which one is greater - even if the two */
		/* segments are alpha or if they are numeric.  don't return  */
		/* if they are equal because there might be more segments to */
		/* compare */
		rc = strcmp(one, two);
		if (rc) {
			ret = rc < 1 ? -1 : 1;
			goto cleanup;
		}

		/* restore character that was replaced by null above */
		*ptr1 = oldch1;
		one = ptr1;
		*ptr2 = oldch2;
		two = ptr2;
	}

	/* this catches the case where all numeric and alpha segments have */
	/* compared identically but the segment separating characters were */
	/* different */
	if ((!*one) && (!*two)) {
		ret = 0;
		goto cleanup;
	}

	/* the final showdown. we never want a remaining alpha string to
	 * beat an empty string. the logic is a bit weird, but:
	 * - if one is empty and two is not an alpha, two is newer.
	 * - if one is an alpha, two is newer.
	 * - otherwise one is newer.
	 * */
	if ( (!*one && !isalpha((int)*two))
			|| isalpha((int)*one) ) {
		ret = -1;
	} else {
		ret = 1;
	}

cleanup:
	free(str1);
	free(str2);
	return ret;
}

int SYMEXPORT alpm_pkg_vercmp(const char *a, const char *b)
{
	char *full1, *full2;
	const char *epoch1, *ver1, *rel1;
	const char *epoch2, *ver2, *rel2;
	int ret;

	/* ensure our strings are not null */
	if(!a && !b) {
		return 0;
	} else if(!a) {
		return -1;
	} else if(!b) {
		return 1;
	}
	/* another quick shortcut- if full version specs are equal */
	if(strcmp(a, b) == 0) {
		return 0;
	}

	/* Parse both versions into [epoch:]version[-release] triplets. We probably
	 * don't need epoch and release to support all the same magic, but it is
	 * easier to just run it all through the same code. */
	full1 = strdup(a);
	full2 = strdup(b);

	/* parseEVR modifies passed in version, so have to dupe it first */
	parseEVR(full1, &epoch1, &ver1, &rel1);
	parseEVR(full2, &epoch2, &ver2, &rel2);

	ret = rpmvercmp(epoch1, epoch2);
	if(ret == 0) {
		ret = rpmvercmp(ver1, ver2);
		if(ret == 0 && rel1 && rel2) {
			ret = rpmvercmp(rel1, rel2);
		}
	}

	free(full1);
	free(full2);
	return ret;
}
