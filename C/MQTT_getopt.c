#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <stdbool.h>
#include <memory.h>

#include "MQTT_getopt.h"

/* copied from
https://www.gnu.org/software/libc/manual/html_node/Getopt-Long-Option-Example.html
and modified to meet my needs. Build with
cc -Wall -o MQTT_getopt MQTT_getopt.c
*/

/* Flag set by ‘--verbose’. */
static int verbose_flag;

void usage(const char* progname)
{
    printf("%s\n"
        " [-v|--verbose] default not verbose\n"
        " [-b|--broker hostname] MQTT broker, default \"localhost\"\n"
        " [-i|--interval nnn] update interval, default 900s\n"
        " [-e|--extra \"cmd\"] cmd for extra payload, default none\n",
        progname);
}

int parse_args(int argc, char **argv, MQTT_options *opts)
{
    int c;

    // set some default values
    if (opts == NULL)
    {
        return -1;
    }
    else
    {
        *opts = (MQTT_options){
            false,
            "localhost",
            15 * 60,
            NULL,
        };
    }

    while (1)
    {
        static struct option long_options[] =
            {
                /* These options set a flag. */
                {"verbose", no_argument, &verbose_flag, 1},
                /* These options don’t set a flag.
                   We distinguish them by their indices. */
                {"broker", required_argument, 0, 'b'},
                {"interval", required_argument, 0, 'i'},
                {"extra", required_argument, 0, 'e'},
                {0, 0, 0, 0}};
        /* getopt_long stores the option index here. */
        int option_index = 0;

        c = getopt_long(argc, argv, "vb:i:e:",
                        long_options, &option_index);

        /* Detect the end of the options. */
        if (c == -1)
            break;

        switch (c)
        {
        case 0:
            /* If this option set a flag, do nothing else now. */
            if (long_options[option_index].flag != 0)
                break;
            printf("option %s", long_options[option_index].name);
            if (optarg)
                printf(" with arg %s", optarg);
            printf("\n");
            break;

        case 'v':
            opts->verbose = true;
            break;

        case 'b':
        {
            int len = strlen(optarg);
            if (len > 0) // Can't be zero length string
            {
                opts->broker = malloc(len + 1);
                strcpy(opts->broker, optarg);
            }
            else
            {
                return -1;
            }
            break;
        }

        case 'i':
        {
            char *end_conversion;
            opts->interval = strtol(optarg, &end_conversion, 10);
            // check for failed conversion or unreasonable value
            if (end_conversion == optarg || // did conversion succeed?
                opts->interval == 0)        // reasonable value?
            {
                return -1;
            }
            break;
        }

        case 'e':
        {
            int len = strlen(optarg);
            if (len > 0) // Can't be zero length string
            {
                opts->extra = malloc(len + 1);
                strcpy(opts->extra, optarg);
            }
            else
            {
                return -1;
            }
            break;
        }

        case '?':
            /* getopt_long already printed an error message. */
            return -1;
            break;

        default:
            abort();
        }
    }

    /* Instead of reporting ‘--verbose’
       and ‘--brief’ as they are encountered,
       we report the final status resulting from them. */
    if (verbose_flag)
    {
        opts->verbose = true;
    }

    /* Print any remaining command line arguments (not options). */
    if (optind < argc)
    {
        printf("non-option ARGV-elements: ");
        while (optind < argc)
            printf("%s ", argv[optind++]);
        putchar('\n');
    }

    return 0;
}
