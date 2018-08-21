#!/bin/bash


SENSITIVITY=100
SPEED=160
INERTIA=6
THRESH=8
RESOLUTION=200
DEVFILE=`find /sys/devices/platform/i8042 -name name | xargs grep -Fl TrackPoint | sed 's/\/input\/input[0-9]*\/name$//'`

update_ss() {
  echo ${SENSITIVITY} | sudo tee ${DEVFILE}/sensitivity
  echo ${SPEED} | sudo tee ${DEVFILE}/speed
  echo ${INERTIA} | sudo tee ${DEVFILE}/inertia
  echo ${THRESH} | sudo tee ${DEVFILE}/thresh
  echo ${RESOLUTION} | sudo tee ${DEVFILE}/resolution
}

help() {
    echo "[Usage]: $0 [option]"
    echo "	options:"
    echo "	- find"
    echo "	- udev"
    echo "	- sys"
}

OPTION=$1
if [ "${OPTION}" = "sys" ]; then
  update_ss
  return
elif [ "${OPTION}" = "udev" ]; then
  sudo tee /etc/udev/rules.d/52-trackpoint.rules <<EOF
SUBSYSTEM=="serio", DRIVERS=="psmouse", DEVPATH=="/sys/devices/platform/i8042/serio1/serio2", ATTR{sensitivity}="${SENSITIVITY}", ATTR{speed}="${SPEED}", ATTR{inertia}="${INERTIA}"
EOF
  sudo udevadm control --reload-rules
  sudo udevadm trigger
  return
elif [ "${OPTION}" = "find" ]; then
  echo ${DEVFILE}
  return
else
  help
fi


