/*
 * Copyright (C) 2013 The Android Open Source Project
 * Copyright (C) 2016 The Android Open Source Project
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *  * Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */
#ifndef _LANGINFO_H
#define _LANGINFO_H

// __LP64__

#include <nl_types.h>
#include <xlocale.h>
#include <locale.h>

#define _NL_ITEM(category,index)  (((category) << 10) | (index))

#define _NL_ITEM_CATEGORY(nl)  ((nl) >> 10)
#define _NL_ITEM_INDEX(nl)     ((nl) & 0x3ff)

#define CODESET 1
#define D_T_FMT 2
#define D_FMT 3
#define T_FMT 4
#define T_FMT_AMPM 5
#define AM_STR 6
#define PM_STR 7
#define DAY_1 8
#define DAY_2 9
#define DAY_3 10
#define DAY_4 11
#define DAY_5 12
#define DAY_6 13
#define DAY_7 14
#define ABDAY_1 15
#define ABDAY_2 16
#define ABDAY_3 17
#define ABDAY_4 18
#define ABDAY_5 19
#define ABDAY_6 20
#define ABDAY_7 21
#define MON_1 22
#define MON_2 23
#define MON_3 24
#define MON_4 25
#define MON_5 26
#define MON_6 27
#define MON_7 28
#define MON_8 29
#define MON_9 30
#define MON_10 31
#define MON_11 32
#define MON_12 33
#define ABMON_1 34
#define ABMON_2 35
#define ABMON_3 36
#define ABMON_4 37
#define ABMON_5 38
#define ABMON_6 39
#define ABMON_7 40
#define ABMON_8 41
#define ABMON_9 42
#define ABMON_10 43
#define ABMON_11 44
#define ABMON_12 45
#define ERA 46
#define ERA_D_FMT 47
#define ERA_D_T_FMT 48
#define ERA_T_FMT 49
#define ALT_DIGITS 50
#define RADIXCHAR 51
#define THOUSEP 52
#define YESEXPR 53
#define NOEXPR 54
#define CRNCYSTR 55
#define INT_CURRENCY_SYMBOL 55

#ifdef __cplusplus
extern "C" {
#endif

static char *nl_langinfo_l(nl_item item, locale_t loc)
{
	static const char c_time[] =
		"Sun\0" "Mon\0" "Tue\0" "Wed\0" "Thu\0" "Fri\0" "Sat\0"
		"Sunday\0" "Monday\0" "Tuesday\0" "Wednesday\0"
		"Thursday\0" "Friday\0" "Saturday\0"
		"Jan\0" "Feb\0" "Mar\0" "Apr\0" "May\0" "Jun\0"
		"Jul\0" "Aug\0" "Sep\0" "Oct\0" "Nov\0" "Dec\0"
		"January\0"   "February\0" "March\0"    "April\0"
		"May\0"       "June\0"     "July\0"     "August\0"
		"September\0" "October\0"  "November\0" "December\0"
		"AM\0" "PM\0"
		"%a %b %e %T %Y\0"
		"%m/%d/%y\0"
		"%H:%M:%S\0"
		"%I:%M:%S %p\0"
		"\0"
		"%m/%d/%y\0"
		"0123456789"
		"%a %b %e %T %Y\0"
		"%H:%M:%S";
	static const char c_messages[] = "^[yY]\0" "^[nN]";
	static const char c_numeric[] = ".\0" "";
	static const char c_zero[] = "UTF-8\0" "UTF-8\0"
		"%F %T %z\0" "%F\0" "%T\0" "%I:%M:%S %p\0"
		"AM\0" "PM\0"
		"Sunday\0" "Monday\0" "Tuesday\0" "Wednesday\0"
		"Thursday\0" "Friday\0"	"Saturday\0"
		"Sun\0"	"Mon\0"	"Tue\0"	"Wed\0"	"Thu\0"	"Fri\0"	"Sat\0"
		"January\0" "February\0" "March\0"
		"April\0" "May\0" "June\0"
		"July\0" "August\0" "September\0"
		"October\0" "November\0" "December\0"
		"Jan\0"	"Feb\0"	"Mar\0"	"Apr\0"	"May\0"	"Jun\0"
		"Jul\0"	"Aug\0"	"Sep\0"	"Oct\0"	"Nov\0"	"Dec\0"
		"\0" "\0" "\0" "\0" "\0" ".\0" "\0"
		"^[yY]\0" "^[nN]\0" "\0";

	int cat = item >> 16;
	int idx = item & 65535;
	const char *str;

	if (item == CODESET) return (char *)"UTF-8";

	switch (cat) {
	case 0:
		if (idx > 55) return NULL;
		str = c_zero;
		break;
	case LC_NUMERIC:
		if (idx > 1) return NULL;
		str = c_numeric;
		break;
	case LC_TIME:
		if (idx > 0x31) return NULL;
		str = c_time;
		break;
	case LC_MONETARY:
		if (idx > 0) return NULL;
		str = "";
		break;
	case LC_MESSAGES:
		if (idx > 1) return NULL;
		str = c_messages;
		break;
	default:
		return NULL;
	}

	for (; idx; idx--, str++) for (; *str; str++);
	return (char *)str;
}

static char *nl_langinfo(nl_item item)
{
	return nl_langinfo_l(item, 0);
}

#ifdef __cplusplus
}  // extern "C"
#endif

#endif  /* _LANGINFO_H */

