#include <iostream>

extern void run_xcompile_logic(int argc, char* argv[]);

int main(int argc, char* argv[]) {
    if (argc < 2) return 1; // Silent exit if no flags provided

    // Trigger the iMYou Multi-Compile Support
    run_xcompile_logic(argc, argv);

    return 0;
}
