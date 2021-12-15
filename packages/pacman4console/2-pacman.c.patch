Subject: Fix some problems and add features.

- Problems fixed:
  * Changed screen/window resolution error message.
  * Bugfix for possible buffer overflow when choosing a
    level. (Closes #641652)
  * Bugfix for possible index out of bound when going through
    a border while playing. (Closes #641657)
- Feature to allow create a menu icon for X (Closes: #737997):
  * Game Over screen which allows to exit or to restart.
- Another features:
  * Added a help option (documents before undocumented level
    choosing option).
  * Changed option syntax for level choosing.

Author: Yannic Scheper <ys42@cd42.de>
Author: Alexandre Dantas <eu@alexdantas.net>
Last-Update: 2014-08-13
--- pacman4console.orig/pacman.c
+++ pacman4console/pacman.c
@@ -31,7 +31,7 @@
 * PROTOTYPES *
 *************/
 void IntroScreen();                                     //Show introduction screen and menu
-void CheckCollision();                                  //See if Pacman and Ghosts collided
+int  CheckCollision();                                  //See if Pacman and Ghosts collided
 void CheckScreenSize();                                 //Make sure resolution is at least 32x29
 void CreateWindows(int y, int x, int y0, int x0);       //Make ncurses windows
 void Delay();                                           //Slow down game for better control
@@ -40,11 +40,11 @@ void ExitProgram(const char *message);
 void GetInput();                                        //Get user input
 void InitCurses();                                      //Start up ncurses
 void LoadLevel(char *levelfile);                        //Load level into memory
-void MainLoop();                                        //Main program function
+int  MainLoop();                                        //Main program function
 void MoveGhosts();                                      //Update Ghosts' location
 void MovePacman();                                      //Update Pacman's location
 void PauseGame();                                       //Pause
-
+void PrintHelp(char* name);                             //Print help and exit
 
 /*******************
 * GLOBAL VARIABLES *
@@ -76,41 +76,71 @@ int tleft = 0;
 ****************************************************************/
 int main(int argc, char *argv[100]) {
 
-    int j = 0;
+    int loop = 1;       //loop program? 0 = no, 1 = yes
+    char* level = NULL; //level to load
+    int j = 1;
+    int i;
+    for(i = 1; i < argc; ++i) {
+        if(strcmp(argv[i], "--help") == 0 || strcmp(argv[i], "-h") == 0) {
+            PrintHelp(argv[0]);
+            return 0;
+        }
+        else if(strncmp(argv[i], "--level=", 8) == 0) {
+            level = argv[i];
+            level += 8;
+            int len = strlen(level);
+            if(len == 0) {
+                level = NULL;
+            }
+            else if(len == 1) {
+                for(LevelNumber = '1'; LevelNumber <= '9'; LevelNumber++) {
+                    if(LevelNumber == level[0]) {
+                        j = LevelNumber - '0';
+                        level = NULL;
+                        break;
+                    }
+                }
+            }
+        }
+        else {
+            PrintHelp(argv[0]);
+            return 0;
+        }
+    }
+
     srand( (unsigned)time( NULL ) );
 
     InitCurses();                   //Must be called to start ncurses
     CheckScreenSize();              //Make sure screen is big enough
     CreateWindows(29, 28, 1, 1);    //Create the main and status windows
 
-    //If they specified a level to load
-    if((argc > 1) && (strlen(argv[1]) > 1)) {
-        argv[1][99] = '\0';
-        LoadLevel(argv[1]);         //Load it and...
-        MainLoop();                 //Start the game
-    }
-
-    //If they did not enter a level, display intro screen then use default levels
-    else {
-        IntroScreen();              //Show intro "movie"
-        j = 1;                      //Set initial level to 1
-
-        if(argc > 1) j = argv[1][0] - '0';    //They specified a level on which to start (1-9)
-
-        //Load 9 levels, 1 by 1, if you can beat all 9 levels in a row, you're awesome
-        for(LevelNumber = j; LevelNumber < 10; LevelNumber++) {
-
-            //Replace level string underscore with the actual level number (see pacman.h)
-            LevelFile[strlen(LevelFile) - 6] = '0';
-            LevelFile[strlen(LevelFile) - 5] = LevelNumber + '0';
-
-            LoadLevel(LevelFile);   //Load level into memory
-            Invincible = 0;         //Reset invincibility with each new level
-            MainLoop();             //Start the level
+    IntroScreen();              //Show intro "movie"
 
+    int start_lives = Lives;
+    int start_points = Points;
+    do {
+        Lives = start_lives;
+        Points = start_points;
+        if(level == NULL) {
+            //j = 1;
+            //Load levels, 1 by 1, if you can beat all 9 levels in a row, you're awesome
+            for(LevelNumber = j; LevelNumber < 10; LevelNumber++) {
+                            LevelFile[strlen(LevelFile) - 6] = '0';
+                LevelFile[strlen(LevelFile) - 5] = LevelNumber + '0';
+                LoadLevel(LevelFile);
+                Invincible = 0;            //Reset invincibility
+                if(MainLoop() == 1) break;
+            }
         }
+        else {
+            //Load special non-standard level
+            LoadLevel(level);
+             Invincible = 0;            //Reset invincibility
+             MainLoop();
+         }
 
-    }
+        if(GameOverScreen() == 1) loop = 0;
+    } while(loop == 1);
 
     //Game has ended, deactivate and end program
     ExitProgram(EXIT_MSG);
@@ -125,7 +155,7 @@ int main(int argc, char *argv[100]) {
 * Returns:     none                                             *
 * Description: Check and handle if Pacman collided with a ghost *
 ****************************************************************/
-void CheckCollision() {
+int CheckCollision() {
 
     //Temporary variable
     int a = 0;
@@ -165,7 +195,7 @@ void CheckCollision() {
                 usleep(1000000);
 
                 //If no more lives, game over
-                if(Lives == -1) ExitProgram(END_MSG);
+                if(Lives == -1) return 1;
 
                 //If NOT game over...
 
@@ -187,6 +217,7 @@ void CheckCollision() {
             }
         }
     }
+    return 0;
 }
 
 /****************************************************************
@@ -203,13 +234,41 @@ void CheckScreenSize() {
         if((h < 32) || (w < 29)) {
                 endwin();
                 fprintf(stderr, "\nSorry.\n");
-                fprintf(stderr, "To play Pacman for Console, your console window must be at least 32x29\n");
+                fprintf(stderr, "To play Pacman for Console, your console window must be at least 29x32\n");
                 fprintf(stderr, "Please resize your window/resolution and re-run the game.\n\n");
                 exit(0);
         }
 
 }
 
+int GameOverScreen() {
+    char chr = ' ';
+    int a, b;
+    for(a = 0; a < 29; a++) for(b = 0; b < 28; b++) {
+        mvwaddch(win, a, b, chr);
+    }
+
+    wattron(win, COLOR_PAIR(Pacman));
+    mvwprintw(win, 8, 11, "Game Over");
+
+    wattron(win, COLOR_PAIR(Normal));
+    mvwprintw(win, 14, 2, "Press q to quit ...");
+    mvwprintw(win, 16, 2, "... or any other key");
+    mvwprintw(win, 17, 6, "to play again");
+
+    wrefresh(win);
+
+    //And wait
+    int chtmp;
+    do {
+        chtmp = getch();
+    } while (chtmp == ERR);
+
+    if(chtmp == 'q' || chtmp == 'Q')
+        return 1;
+    return 0;
+}
+
 /****************************************************************
 * Function:    CreateWindows()                                  *
 * Parameters:  y, x, y0, x0 (coords and size of window)         *
@@ -494,7 +553,7 @@ void IntroScreen() {
 * Returns:     none                                             *
 * Description: Open level file and load it into memory          *
 ****************************************************************/
-void LoadLevel(char levelfile[100]) {
+void LoadLevel(char* levelfile) {
 
     int a = 0; int b = 0;
     size_t l;
@@ -555,7 +614,7 @@ void LoadLevel(char levelfile[100]) {
 * Returns:     none                                             *
 * Description: Control the main execution of the game           *
 ****************************************************************/
-void MainLoop() {
+int MainLoop() {
 
     DrawWindow();                    //Draw the screen
     wrefresh(win); wrefresh(status); //Refresh it just to make sure
@@ -564,15 +623,15 @@ void MainLoop() {
     /* Move Pacman. Move ghosts. Check for extra life awarded
     from points. Pause for a brief moment. Repeat until all pellets are eaten */
     do {
-        MovePacman();    DrawWindow();    CheckCollision();
-        MoveGhosts();    DrawWindow();    CheckCollision();
+        MovePacman();    DrawWindow();    if (CheckCollision() == 1) return 1;
+        MoveGhosts();    DrawWindow();    if (CheckCollision() == 1) return 1;
         if(Points > FreeLife) { Lives++; FreeLife *= 2;}
         Delay();
     } while (Food > 0);
 
     DrawWindow();                   //Redraw window and...
     usleep(1000000);                //Pause, level complete
-
+    return 0;
 }
 
 /****************************************************************
@@ -748,3 +807,12 @@ void PauseGame() {
     } while (chtmp == ERR);
 
 }
+
+void PrintHelp(char* name) {
+    printf("Usage: %s [OPTION]\n\n", name);
+    printf("Options:\n");
+    printf("  -h, --help        print help\n");
+    printf("  --level=[1..9]    start at specified standard level\n");
+    printf("  --level=LEVEL     play specified non-standard LEVEL\n");
+}
+
