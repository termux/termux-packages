#ifdef  __cplusplus
extern "C" {
#endif

const char *termux_passwd_hash(char* pass);
int termux_change_passwd(const char *user, const char *user_hash);
int termux_auth(const char *user, const char *user_hash);

#ifdef  __cplusplus
}
#endif
