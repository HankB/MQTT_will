/*******************************************************************************
 * Copyright (c) 2012, 2020 IBM Corp.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v2.0
 * and Eclipse Distribution License v1.0 which accompany this distribution. 
 *
 * The Eclipse Public License is available at 
 *   https://www.eclipse.org/legal/epl-2.0/
 * and the Eclipse Distribution License is available at 
 *   http://www.eclipse.org/org/documents/edl-v10.php.
 *
 * Contributors:
 *    Ian Craggs - initial contribution
 *    Hank Barta - mods for https://github.com/HankB/MQTT_will/tree/main/C
 *******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include "MQTTClient.h"
#include <stdbool.h>

#include "MQTT_getopt.h"

static const char client_prefix[] = "MQTT_will.";
#define ID_LEN 30
static char client_id[ID_LEN];
#define TOPIC_LEN 40
static char topic[TOPIC_LEN];  // used for normal and will messages
static time_t t;
static const char topic_format[] = "CM/%s/NA/state";
#define HOSTNAME_LEN    1024
static char hostname[HOSTNAME_LEN];
static const char connected_payload[] = "here";
#define PAYLOAD_LEN    1024
static char payload_buffer[PAYLOAD_LEN];

#define QOS         0
#define TIMEOUT     10000L

MQTTClient client;

static bool chatty=false;    // control console output

// forward declaration
int send_message(const char * msg_topic, const char * msg_payload);

// Build payload message, JSON format including timestamp and status
// ee.g. '{ "t": nnnnnn, "status": "status" }'
const char* build_payload(char buf[], uint buf_len, const char* status)
{
    snprintf(buf, buf_len, "{ \"t\": %ld, \"status\": \"%s\" }", 
            time(NULL), status);
    return buf;
}

int start_mqtt_connection( const char * broker, const char * will_msg)
{
    MQTTClient_willOptions will_opts = MQTTClient_willOptions_initializer;
    MQTTClient_connectOptions conn_opts = MQTTClient_connectOptions_initializer;

    // prepare some strings used to communicate with broker
    srand((unsigned) time(&t)); // seed RNG
    snprintf(client_id, ID_LEN, "%s%8.8X", client_prefix, rand());
    gethostname(hostname, HOSTNAME_LEN);
    snprintf(topic, HOSTNAME_LEN+sizeof(topic), topic_format, hostname);
    int rc;

    if ((rc = MQTTClient_create(&client, broker, client_id,
        MQTTCLIENT_PERSISTENCE_NONE, NULL)) != MQTTCLIENT_SUCCESS)
    {
         if(chatty) printf("Failed to create client, return code %d\n", rc);
         return rc;
    }
    will_opts.topicName = topic;
    will_opts.message = will_msg;
    will_opts.retained = 0;
    will_opts.qos = 0;
    will_opts.struct_version = 0;

    conn_opts.keepAliveInterval = 20;
    conn_opts.cleansession = 1;
    conn_opts.will = &will_opts;

    if ((rc = MQTTClient_connect(client, &conn_opts)) != MQTTCLIENT_SUCCESS)
    {
        if(chatty) printf("Failed to connect, return code %d\n", rc);
         return rc;
    }

    rc = send_message(topic, build_payload(payload_buffer, PAYLOAD_LEN, "here"));

    return rc; // should be MQTTCLIENT_SUCCESS
}

int send_message(const char * msg_topic, const char * msg_payload)
{
    MQTTClient_message pubmsg = MQTTClient_message_initializer;
    MQTTClient_deliveryToken token;
    int rc;

    pubmsg.payload = (void*)msg_payload;
    pubmsg.payloadlen = (int)strlen(msg_payload);
    pubmsg.qos = QOS;
    pubmsg.retained = 0;
    if ((rc = MQTTClient_publishMessage(client, msg_topic, &pubmsg, &token))
            != MQTTCLIENT_SUCCESS)
    {
         if (chatty) printf("Failed to publish message, return code %d\n", rc);
         return rc;
    }

    if(chatty) printf("Waiting for up to %d seconds for publication of %s\n"
            "on topic %s for client with ClientID: %s\n",
            (int)(TIMEOUT/1000), connected_payload, topic, client_id);
    rc = MQTTClient_waitForCompletion(client, token, TIMEOUT);
    if(chatty) printf("Message with delivery token %d delivered\n", token);
    return rc; // should be MQTTCLIENT_SUCCESS
}


int main(int argc, char* argv[])
{
    int rc;
    time_t  sent_time;

    MQTT_options        opts;
    if(parse_args(argc, argv, &opts) != 0) {
        usage(argv[0]);
        exit(-1);
    }
    chatty = opts.verbose;

    // connect
    while( start_mqtt_connection( opts.broker, 
                build_payload(payload_buffer, PAYLOAD_LEN, "gone"))
            != MQTTCLIENT_SUCCESS)
    {
        sleep(5);       // delay and try again
    }
    sent_time = time(NULL);

    while(true)
    {
        if(time(NULL) - sent_time > opts.interval)
        {
            while ( send_message(topic,
                        build_payload(payload_buffer, PAYLOAD_LEN, "still"))
                    != MQTTCLIENT_SUCCESS)
            {
                // send, retry connect if send does not succeed
                while( start_mqtt_connection( opts.broker,
                            build_payload(payload_buffer, PAYLOAD_LEN, "gone"))
                        != MQTTCLIENT_SUCCESS)
                {
                    sleep(5);       // delay and try again
                }
                break;
            }
        sent_time = time(NULL);
        }
        sleep(1);           // pause one second
        MQTTClient_yield(); // process MQTT stuff
    }

    if ((rc = MQTTClient_disconnect(client, 10000)) != MQTTCLIENT_SUCCESS)
    {
    	if(chatty) printf("Failed to disconnect, return code %d\n", rc);
    }
    MQTTClient_destroy(&client);
    return rc;
}
