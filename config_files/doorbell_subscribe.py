#!/usr/bin/env python
import paho.mqtt.client as mqtt
import os
import time


# The callback for when the client receives a CONNACK response from the server.
def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))

    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe("doorbell", qos=0)

# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, msg):
    print(msg.payload)
    if msg.topic == "doorbell" and msg.payload == b"ring":
        print('Doorbell is ringing')
        # os.system("mpg123 /usr/share/sounds/freedesktop/stereo/doorbell-1.mp3")
        os.system("/usr/bin/aplay -D plughw:1,0 /usr/share/sounds/freedesktop/stereo/doorbell-1.wav")

time.sleep(5)
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect("10.0.0.201", 1883, 60)

# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
client.loop_forever()

