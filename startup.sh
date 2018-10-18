#!/bin/bash

# Start ssh server
/usr/sbin/sshd -D &

source /root/.bashrc

# start vnc server
vncserver -kill $VNC_DISPLAY
rm -rfv /tmp/.X*-lock /tmp/.X11-unix
vncserver $VNC_DISPLAY -geometry $VNC_GEOMETRY

tail -f /root/.vnc/*$VNC_DISPLAY.log