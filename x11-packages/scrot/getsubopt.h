#ifndef _GETSUBOPT_H
#define _GETSUBOPT_H

#ifdef __cplusplus
extern "C" {
#endif

#if defined __ANDROID__ && __ANDROID_API__ < 26
int getsubopt(char **, char *const *, char **);
#endif

#ifdef __cplusplus
}
#endif

#endif /* _GETSUBOPT_H */
