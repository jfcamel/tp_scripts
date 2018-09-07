#!/bin/bash


SENSITIVITY=100
SPEED=160
INERTIA=6
THRESH=5
RESOLUTION=200
DEVFILE=`find /sys/devices/platform/i8042 -name name | xargs grep -Fl TrackPoint | sed 's/\/input\/input[0-9]*\/name$//'`

update_ss() {
  echo ${SENSITIVITY} | tee ${DEVFILE}/sensitivity
  echo ${SPEED} | tee ${DEVFILE}/speed
  echo ${INERTIA} | tee ${DEVFILE}/inertia
  echo ${THRESH} | tee ${DEVFILE}/thresh
  echo ${RESOLUTION} | tee ${DEVFILE}/resolution
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
elif [ "${OPTION}" = "udev" ]; then
  tee /etc/udev/rules.d/52-trackpoint.rules <<EOF
SUBSYSTEM=="serio", DRIVERS=="psmouse", DEVPATH=="/sys/devices/platform/i8042/serio1/serio2", ATTR{sensitivity}="${SENSITIVITY}", ATTR{speed}="${SPEED}", ATTR{inertia}="${INERTIA}"
EOF
  udevadm control --reload-rules
  udevadm trigger
elif [ "${OPTION}" = "find" ]; then
  echo ${DEVFILE}
else
  help
fi


