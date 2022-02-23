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

static const char broker[] = "olive";
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
#define QOS         0
#define TIMEOUT     10000L

int main(int argc, char* argv[])
{
    MQTTClient client;
    MQTTClient_connectOptions conn_opts = MQTTClient_connectOptions_initializer;
    MQTTClient_message pubmsg = MQTTClient_message_initializer;
    MQTTClient_deliveryToken token;
    MQTTClient_willOptions will_opts = MQTTClient_willOptions_initializer;

    int rc;

    // prepare some strings used to communicate with broker
    srand((unsigned) time(&t)); // seed RNG
    snprintf(client_id, ID_LEN, "%s%8.8X", client_prefix, rand());
    gethostname(hostname, HOSTNAME_LEN);
    snprintf(topic, HOSTNAME_LEN+sizeof(topic), topic_format, hostname);


    if ((rc = MQTTClient_create(&client, broker, client_id,
        MQTTCLIENT_PERSISTENCE_NONE, NULL)) != MQTTCLIENT_SUCCESS)
    {
         printf("Failed to create client, return code %d\n", rc);
         exit(EXIT_FAILURE);
    }

    will_opts.topicName = topic;
    will_opts.message = "gone";
    will_opts.retained = 0;
    will_opts.qos = 0;
    will_opts.struct_version = 0;

    conn_opts.keepAliveInterval = 20;
    conn_opts.cleansession = 1;
    conn_opts.will = &will_opts;
    if ((rc = MQTTClient_connect(client, &conn_opts)) != MQTTCLIENT_SUCCESS)
    {
        printf("Failed to connect, return code %d\n", rc);
        exit(EXIT_FAILURE);
    }


    pubmsg.payload = (void*)connected_payload;
    pubmsg.payloadlen = (int)strlen(connected_payload);
    pubmsg.qos = QOS;
    pubmsg.retained = 0;
    if ((rc = MQTTClient_publishMessage(client, topic, &pubmsg, &token)) != MQTTCLIENT_SUCCESS)
    {
         printf("Failed to publish message, return code %d\n", rc);
         exit(EXIT_FAILURE);
    }

    printf("Waiting for up to %d seconds for publication of %s\n"
            "on topic %s for client with ClientID: %s\n",
            (int)(TIMEOUT/1000), connected_payload, topic, client_id);
    rc = MQTTClient_waitForCompletion(client, token, TIMEOUT);
    printf("Message with delivery token %d delivered\n", token);

    abort(); // provoke broker to publish will message

    if ((rc = MQTTClient_disconnect(client, 10000)) != MQTTCLIENT_SUCCESS)
    	printf("Failed to disconnect, return code %d\n", rc);
    MQTTClient_destroy(&client);
    return rc;
}
