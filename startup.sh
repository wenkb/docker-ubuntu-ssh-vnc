#!/bin/bash

# Start ssh server
/usr/sbin/sshd -D &

# start vnc server
vncserver -kill $VNC_DISPLAY
rm -rfv /tmp/.X*-lock /tmp/.X11-unix
vncserver $DISPLAY -geometry $VNC_GEOMETRY
