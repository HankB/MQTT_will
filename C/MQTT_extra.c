#include <stdio.h>
#include <string.h>

#include "MQTT_will.h"

/*
Code to capture output from the "extra" command and return it in the buffer provided.
*/

int get_extra(const char *cmd, char *buff, size_t buff_len)
{
    FILE *fp;

    fp = popen(cmd, "r"); /* Unix */
    if (fp == NULL)
    {
        puts("Unable to open process");
        return (-1);
    }

    buff[0] = '\0'; // null terminate input buffer
    while (fgets(buff + strlen(buff), buff_len - strlen(buff), fp) && buff_len - strlen(buff) > 1)
    {
        ;
    }

    pclose(fp);
    return strlen(buff);
}
