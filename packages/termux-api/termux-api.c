// termux-api.c - helper binary for calling termux api classes
// Usage: termux-api ${API_METHOD} ${ADDITIONAL_FLAGS}
//        This executes
//          am broadcast com.termux.api/.TermuxApiReceiver --es socket_input ${INPUT_SOCKET} 
//                                                        --es socket_output ${OUTPUT_SOCKET}
//                                                        --es ${API_METHOD}
//                                                        ${ADDITIONAL_FLAGS}
//        where ${INPUT_SOCKET} and ${OUTPUT_SOCKET} are addresses to linux abstract namespace sockets,
//        used to pass on stdin to the java implementation and pass back output from java to stdout.
#define _POSIX_SOURCE
#define _GNU_SOURCE
#include <fcntl.h>
#include <pthread.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/un.h>
#include <time.h>
#include <unistd.h>

// Function which execs "am broadcast ..".
void exec_am_broadcast(int argc, char** argv, char* input_address_string, char* output_address_string)
{
    // Redirect stdout to /dev/null (but leave stderr open):
    close(STDOUT_FILENO);
    open("/dev/null", O_RDONLY);
    // Close stdin:
    close(STDIN_FILENO);

    // The user is calculated from the uid in android.os.UserHandle#getUserId(int uid) as "uid / 100000", so we do the same:
    uid_t current_uid = getuid();
    int android_user_id = current_uid / 100000;
    char* android_user_id_string;
    if (asprintf(&android_user_id_string, "%d", android_user_id) == -1) {
        fprintf(stderr, "asprintf() error");
        return;
    }

    int const extra_args = 15; // Including ending NULL.
    char** child_argv = malloc((sizeof(char*)) * (argc + extra_args));

    child_argv[0] = "am";
    child_argv[1] = "broadcast";
    child_argv[2] = "--user";
    child_argv[3] = android_user_id_string;
    child_argv[4] = "-n";
    child_argv[5] = "com.termux.api/.TermuxApiReceiver";
    child_argv[6] = "--es";
    // Input/output are reversed for the java process (our output is its input):
    child_argv[7] = "socket_input";
    child_argv[8] = output_address_string;
    child_argv[9] = "--es";
    child_argv[10] = "socket_output";
    child_argv[11] = input_address_string;
    child_argv[12] = "--es";
    child_argv[13] = "api_method";
    child_argv[14] = argv[1];

    // Copy the remaining arguments -2 for first binary and second api name:
    memcpy(child_argv + extra_args, argv + 2, (argc-1) * sizeof(char*));

    // End with NULL:
    child_argv[argc + extra_args] = NULL;

    // Use an a executable taking care of PATH and LD_LIBRARY_PATH:
    char const* const am_executable = "/data/data/com.termux/files/usr/bin/am";
    execv(am_executable, child_argv);

    perror("execv(\"/system/bin/am\")");
    exit(1);
}

void generate_uuid(char* str) {
    sprintf(str, "%x%x-%x-%x-%x-%x%x%x", 
            rand(), rand(),                // Generates a 64-bit Hex number
            (uint32_t) getpid(),           // Generates a 32-bit Hex number
            ((rand() & 0x0fff) | 0x4000),  // Generates a 32-bit Hex number of the form 4xxx (4 indicates the UUID version)
            rand() % 0x3fff + 0x8000,      // Generates a 32-bit Hex number in the range [0x8000, 0xbfff]
            rand(), rand(), rand());       // Generates a 96-bit Hex number
}

// Thread function which reads from stdin and writes to socket.
void* transmit_stdin_to_socket(void* arg) {
    int output_server_socket = *((int*) arg);
    struct sockaddr_un remote_addr;
    socklen_t addrlen = sizeof(remote_addr);
    int output_client_socket = accept(output_server_socket, (struct sockaddr*) &remote_addr, &addrlen);

    int len;
    char buffer[1024];
    while (len = read(STDIN_FILENO, &buffer, sizeof(buffer)-1), len > 0) {
        if (write(output_client_socket, buffer, len) < 0) break;
    }
    // Close output socket on end of input:
    close(output_client_socket);
    return NULL;
}

// Main thread function which reads from input socket and writes to stdout.
void transmit_socket_to_stdout(int input_socket_fd) {
    int len;
    char buffer[1024];
    while ((len = read(input_socket_fd, &buffer, sizeof(buffer)-1)) > 0) {
        buffer[len] = 0;
        write(STDOUT_FILENO, buffer, len);
    }
    if (len < 0) perror("read()");
}

int main(int argc, char** argv) {
    // Do not transform children into zombies when they terminate:
    struct sigaction sigchld_action = { .sa_handler = SIG_DFL, .sa_flags = SA_RESTART | SA_NOCLDSTOP | SA_NOCLDWAIT };
    sigaction(SIGCHLD, &sigchld_action, NULL);

    char input_address_string[100];  // This program reads from it.
    char output_address_string[100]; // This program writes to it.

    // Seed the random number generator:
    struct timeval time;
    gettimeofday(&time,NULL);
    srand((time.tv_sec * 1000) + (time.tv_usec / 1000));

    generate_uuid(input_address_string);
    generate_uuid(output_address_string);

    struct sockaddr_un input_address = { .sun_family = AF_UNIX };
    struct sockaddr_un output_address = { .sun_family = AF_UNIX };
    // Leave struct sockaddr_un.sun_path[0] as 0 and use the UUID string as abstract linux namespace:
    strncpy(&input_address.sun_path[1], input_address_string, strlen(input_address_string));
    strncpy(&output_address.sun_path[1], output_address_string, strlen(output_address_string));

    int input_server_socket = socket(AF_UNIX, SOCK_STREAM|SOCK_CLOEXEC, 0);
    if (input_server_socket == -1) { perror("socket()"); return 1; }
    int output_server_socket = socket(AF_UNIX, SOCK_STREAM|SOCK_CLOEXEC, 0);
    if (output_server_socket == -1) { perror("socket()"); return 1; }

    if (bind(input_server_socket, (struct sockaddr*) &input_address, sizeof(sa_family_t) + strlen(input_address_string) + 1) == -1) {
        perror("bind(input)");
        return 1;
    }
    if (bind(output_server_socket, (struct sockaddr*) &output_address, sizeof(sa_family_t) + strlen(output_address_string) + 1) == -1) {
        perror("bind(output)");
        return 1;
    }

    if (listen(input_server_socket, 1) == -1) { perror("listen()"); return 1; }
    if (listen(output_server_socket, 1) == -1) { perror("listen()"); return 1; }

    pid_t fork_result = fork();
    switch (fork_result) {
        case -1: perror("fork()"); return 1;
        case 0: exec_am_broadcast(argc, argv, input_address_string, output_address_string); return 0;
    }

    struct sockaddr_un remote_addr;
    socklen_t addrlen = sizeof(remote_addr);
    int input_client_socket = accept(input_server_socket, (struct sockaddr*) &remote_addr, &addrlen);

    pthread_t transmit_thread;
    pthread_create(&transmit_thread, NULL, transmit_stdin_to_socket, &output_server_socket);

    transmit_socket_to_stdout(input_client_socket);

    return 0;
}

