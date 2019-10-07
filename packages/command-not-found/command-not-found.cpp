#include <iostream>
#include <cstring>
#include <map>
#include <list>

using namespace std;

list<string> games_commands = {
#ifdef __aarch64__
# include "games/commands-aarch64.h"
#elif defined __arm__
# include "games/commands-arm.h"
#elif defined __i686__
# include "games/commands-i686.h"
#elif defined __x86_64__
# include "games/commands-x86_64.h"
#else
# error Failed to detect arch
#endif
};

list<string> main_commands = {
#ifdef __aarch64__
# include "main/commands-aarch64.h"
#elif defined __arm__
# include "main/commands-arm.h"
#elif defined __i686__
# include "main/commands-i686.h"
#elif defined __x86_64__
# include "main/commands-x86_64.h"
#else
# error Failed to detect arch
#endif
};

list<string> root_commands = {
#ifdef __aarch64__
# include "root/commands-aarch64.h"
#elif defined __arm__
# include "root/commands-arm.h"
#elif defined __i686__
# include "root/commands-i686.h"
#elif defined __x86_64__
# include "root/commands-x86_64.h"
#else
# error Failed to detect arch
#endif
};

list<string> science_commands = {
#ifdef __aarch64__
# include "science/commands-aarch64.h"
#elif defined __arm__
# include "science/commands-arm.h"
#elif defined __i686__
# include "science/commands-i686.h"
#elif defined __x86_64__
# include "science/commands-x86_64.h"
#else
# error Failed to detect arch
#endif
};

list<string> unstable_commands = {
#ifdef __aarch64__
# include "unstable/commands-aarch64.h"
#elif defined __arm__
# include "unstable/commands-arm.h"
#elif defined __i686__
# include "unstable/commands-i686.h"
#elif defined __x86_64__
# include "unstable/commands-x86_64.h"
#else
# error Failed to detect arch
#endif
};

list<string> x11_commands = {
#ifdef __aarch64__
# include "x11/commands-aarch64.h"
#elif defined __arm__
# include "x11/commands-arm.h"
#elif defined __i686__
# include "x11/commands-i686.h"
#elif defined __x86_64__
# include "x11/commands-x86_64.h"
#else
# error Failed to detect arch
#endif
};

struct info {string owner, repository;};

inline int termux_min3(int a, int b, int c) {
	return (a < b ? (a < c ? a : c) : (b < c ? b : c));
}

int termux_levenshtein_distance(char const* s1, char const* s2) {
  int s1len = strlen(s1);
  int s2len = strlen(s2);
  int x, y;
  int **matrix;
  int distance;
  matrix = (int **) malloc(sizeof *matrix * (s2len+1));
  if (matrix) {
    matrix[0] = (int *) malloc(sizeof *matrix[0] * (s1len+1));
  } else {
    cerr << "Memory allocation seem to have failed" << endl;
    return -2;
  }
  if (matrix[0]) {
    matrix[0][0] = 0;
  } else {
    cerr << "Memory allocation seem to have failed" << endl;
    return -3;
  }
  for (x = 1; x <= s2len; x++) {
    matrix[x] = (int *) malloc(sizeof *matrix[x] * (s1len+1));
    matrix[x][0] = matrix[x-1][0] + 1;
  }
  for (y = 1; y <= s1len; y++) {
    matrix[0][y] = matrix[0][y-1] + 1;
  }
  for (x = 1; x <= s2len; x++) {
    for (y = 1; y <= s1len; y++) {
      matrix[x][y] = termux_min3(matrix[x-1][y] + 1, matrix[x][y-1] + 1, matrix[x-1][y-1] + (s1[y-1] == s2[x-1] ? 0 : 1));
    }
  }
  distance = matrix[s2len][s1len];

  if (matrix) {
    for (x = 0; x <= s2len; x++) {
      free(matrix[x]);
    }
  }
  free(matrix);
  return distance;
}

int termux_look_for_packages(const char* command_not_found, list<string>* cmds, int* best_distance, void* guesses_at_best_distance, const char repository[]) {
  string current_package;
  string current_binary;
  int distance;
  map<string, info>* pkg_map = (map<string, info>*) guesses_at_best_distance;
  for (list<string>::iterator it = (*cmds).begin(); it != (*cmds).end(); ++it) {
    string current_line = *it;
    if (current_line[0] != ' ')
    {
      current_package = current_line;
    } else {
      current_binary = current_line.substr(1);
      distance = termux_levenshtein_distance(command_not_found, current_binary.c_str());
      if (distance == 0)
      {
        // Perfect match, might be perfect matches in other packages or repos also though
        *best_distance = 0;
        (*pkg_map).insert(pair<string,info>(current_binary, {current_package, repository}));
      } else if (*best_distance == distance) {
        // As good as our previously best match
        (*pkg_map).insert(pair<string,info>(current_binary, {current_package, repository}));
      } else if (*best_distance == -1 || *best_distance > distance) {
        // New best match
        (*pkg_map).clear();
        *best_distance = distance;
        (*pkg_map).insert(pair<string,info>(current_binary, {current_package, repository}));
      } else if (distance < -1) {
        return distance;
      }
    }
  }
  return 0;
}

int main(int argc, const char *argv[]) {
  if (argc != 2) {
    cerr <<  "usage: termux-command-not-found <command>" << endl;
    return 1;
  }

  const char *command = argv[1];
  int best_distance = -1;
  struct info {string owner, repository;};
  map <string, info> package_map;
  termux_look_for_packages(command, &main_commands, &best_distance, &package_map, "");
  termux_look_for_packages(command, &games_commands, &best_distance, &package_map, "game");
  termux_look_for_packages(command, &root_commands, &best_distance, &package_map, "root");
  termux_look_for_packages(command, &science_commands, &best_distance, &package_map, "science");
  termux_look_for_packages(command, &unstable_commands, &best_distance, &package_map, "unstable");
  termux_look_for_packages(command, &x11_commands, &best_distance, &package_map, "x11");

  if (best_distance == -1 || best_distance > 3) {
    cerr << command << ": command not found" << endl;
  } else if (best_distance == 0) {
    cerr << "The program " << command << " is not installed. Install it by executing:" << endl;
    for (map <string, info>::iterator it=package_map.begin(); it!=package_map.end(); ++it) {
      cerr << " pkg install " << it->second.owner;
      if (it->second.repository != "") {
        cerr << ", after subscribing to the " << it->second.repository << "-repo repository" << endl;
      } else {
        cerr << endl;
      }
      if (next(it) != package_map.end()) {
        cerr << "or" << endl;
      }
    }
  } else {
    cerr << "No command " << command << " found, did you mean:" << endl;
    for (map <string, info>::iterator it=package_map.begin(); it!=package_map.end(); ++it) {
      cerr << " Command " << it->first << " in package " << it->second.owner;
      if (!(it->second.repository == "")) {
        cerr << " from the " << it->second.repository << "-repo repository" << endl;
      } else {
        cerr << endl;
      }
    }
  }
  return 127;
}
