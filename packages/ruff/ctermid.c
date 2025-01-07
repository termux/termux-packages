
char *strcpy(char *, const char *);

char *
ctermid(char *s)
{
  if (s == 0)
    return "/dev/tty";
  strcpy(s, "/dev/tty");
  return s;
}
