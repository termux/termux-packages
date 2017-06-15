#include <libgen.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

// Nix calls many binaries with an empty environment, to help with purity.
// Termux provided packages usually need LD_LIBRARY_PATH set.
// If you symlink this binary the name will be called with LD_LIBRARY_PATH.

#define MAX_PATH_SIZE 255

int main(int argc, char **argv) {
  char this[MAX_PATH_SIZE];
  char *name = argv[0];
  ssize_t s = readlink(name, this, MAX_PATH_SIZE);

  const int parent = strlen(dirname(this));
  if (strncmp(name, this, parent) == 0) {
    name += parent;
  }

  char *prefix = getenv("PREFIX");
  if (prefix == NULL) {
    prefix = "/data/data/com.termux/files/usr";
  }

  char ld_library_path[MAX_PATH_SIZE];
  snprintf(ld_library_path, MAX_PATH_SIZE, "%s/lib", prefix);
  setenv("LD_LIBRARY_PATH", ld_library_path, 0);

  char path[MAX_PATH_SIZE];
  snprintf(path, MAX_PATH_SIZE,"%s/bin/%s", prefix, name);
  argv[0] = path;
  return execv(path, argv);
}
