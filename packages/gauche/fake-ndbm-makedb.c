
#include <string.h>
#include <fcntl.h>

#define PATHMAX 1023

int
main(int argc, char **argv)
{
  char pathname[PATHMAX+1];
  char *suffixes[] = { ".dir", ".peg" };

  if (argc != 2 || strlen(argv[1]) + strlen(suffixes[0]) > sizeof(pathname)-1)
    return 1;

  for (size_t i = 0; i < sizeof(suffixes) / sizeof(char *); i++) {
    strncpy(pathname, argv[1], sizeof(pathname)-1);
    strncat(pathname, suffixes[i], sizeof(pathname)-1);
    if (creat(pathname, 0777) < 0)
      return 1;
  }

  return 0;
}
