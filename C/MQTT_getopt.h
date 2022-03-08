/*
* Shared stuff
*/

typedef struct
{
    bool verbose; // extra output?
    char *broker; // broker to connect to
    int interval; // interval between "I'm still here" messages
    char *extra;  // command to provide extra payload content
} MQTT_options;

void usage(const char* progname);
int parse_args(int argc, char **argv, MQTT_options *opts);
