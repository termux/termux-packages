
#ifdef HAVE_CONFIG_H
#include <config.h>
#endif
#ifndef __libacpi_c__
#define __libacpi_c__
#endif


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <signal.h>
#include "libacpi.h"


char termux_bat_buffer[1024];

int
check_acpi(void)
{
    batt_count = 1;
    return 0;
}

int read_termux_battery_status() {
    int pipefd[2];
    pid_t pid;
    int status;

    // Create a pipe
    if (pipe(pipefd) == -1) return 0;

    if ((pid = fork()) == 0) { // Child process
        close(pipefd[0]);
        dup2(pipefd[1], STDOUT_FILENO);
        close(pipefd[1]);
        execlp("termux-battery-status", "termux-battery-status", NULL);
        perror("execlp");
        exit(EXIT_FAILURE);
    } else if (pid > 0) { // Parent process
        close(pipefd[1]);
        for (int i = 0; i < 50; i++) {
            if (waitpid(pid, &status, WNOHANG) == pid) {
                ssize_t bytes_read = read(pipefd[0], termux_bat_buffer, sizeof(termux_bat_buffer) - 1);
                termux_bat_buffer[bytes_read] = '\0';
                close(pipefd[0]);
                return 1;
            }
            nanosleep((const struct timespec[]){{0, 100000000L}}, NULL);
        }
        close(pipefd[0]);
        kill(pid, SIGKILL);
        return 0;
    } else {
        return 0;
    }
}

int
read_acad_state(void)
{
    char* buf_ptr;

    if (!read_termux_battery_status()) return -1;

    buf_ptr = strstr(termux_bat_buffer, "\"plugged\"");
    if (buf_ptr == NULL) return (-1);
    buf_ptr = strstr(buf_ptr + sizeof("\"plugged\""), "\"");
    if (buf_ptr == NULL) return (-1);
    if (strncmp(buf_ptr+1, "PLUGGED",   7) == 0) return 1;
    if (strncmp(buf_ptr+1, "UNPLUGGED", 9) == 0) return 0;
    return -1;
}

int
read_acpi_info(int battery)
{
    if (!acpiinfo)
        acpiinfo=(ACPIinfo *)malloc(sizeof(ACPIinfo));
    acpiinfo->present = 0;
    acpiinfo->design_capacity = 0;
    acpiinfo->last_full_capacity = 100;
    acpiinfo->battery_technology = 0;
    acpiinfo->design_voltage = 0;
    acpiinfo->design_capacity_warning = 0;
    acpiinfo->design_capacity_low = 0;
    if (battery > 0) return 0;

    if (battery == 0) acpiinfo->present = 1;
    return 1;
}

int
read_acpi_state(int battery)
{
    char* buf_ptr;

    if (!acpistate)
        acpistate=(ACPIstate *)malloc(sizeof(ACPIstate));
    acpistate->present = 0;
    acpistate->state = UNKNOW;
    acpistate->prate = 0;
    acpistate->rcapacity = 0;
    acpistate->pvoltage = 0;
    acpistate->rtime = 0;
    acpistate->percentage = 0;

    if (battery > 0) return 1;
    
    acpistate->present = 1;

    if (!read_termux_battery_status()) return 0;

    buf_ptr = strstr(termux_bat_buffer, "\"percentage\"");
    if (buf_ptr == NULL) return 0;
    sscanf(buf_ptr, "\"percentage\":%d,", &acpistate->rcapacity);
    acpistate->percentage = acpistate->rcapacity;

    buf_ptr = strstr(termux_bat_buffer, "\"status\"");
    if (buf_ptr == NULL) return 0;
    buf_ptr = strstr(buf_ptr + sizeof("\"status\""), "\"");
    if (buf_ptr == NULL) return 0;
    if (strncmp(buf_ptr+1, "CHARGING", 8) == 0)      acpistate->state = CHARGING;
    if (strncmp(buf_ptr+1, "DISCHARGING", 11) == 0)  acpistate->state = DISCHARGING;
    if (strncmp(buf_ptr+1, "NOT_CHARGING", 12) == 0) acpistate->state = POWER;
    if (strncmp(buf_ptr+1, "FULL", 4) == 0)          acpistate->state = POWER;

    return 1;
}

int
get_fan_status(void)
{
    return 0;
}

const char*
get_temperature(void)
{
    float temperature;
    static char buf[1024];
    char* buf_ptr;
    

    if (!read_termux_battery_status()) return NULL;

    buf_ptr = strstr(termux_bat_buffer, "\"temperature\"");
    if (buf_ptr == NULL) NULL;
    sscanf(buf_ptr, "\"temperature\":%f,", &temperature);

    snprintf(buf, 1024, "%.1f C", temperature);
    return (const char *)buf;
}
