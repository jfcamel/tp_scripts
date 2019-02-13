#!/bin/bash

load_params() {
  SCRIPTDIR=`dirname ${BASH_SOURCE[0]}`
  . ${SCRIPTDIR}/params.sh
}

load_params
DEVFILE=`find /sys/devices/platform/i8042 -name name | xargs grep -Fl TrackPoint | sed 's/\/input\/input[0-9]*\/name$//'`

update_ss() {
  echo -n "sensitivity "
  echo ${SENSITIVITY} | tee ${DEVFILE}/sensitivity
  echo -n "speed "
  echo ${SPEED} | tee ${DEVFILE}/speed
  echo -n "inertia "
  echo ${INERTIA} | tee ${DEVFILE}/inertia
  echo -n "thresh "
  echo ${THRESH} | tee ${DEVFILE}/thresh
  echo -n "upthresh "
  echo ${UPTHRESH} | tee ${DEVFILE}/upthresh
  echo -n "jenks "
  echo ${JENKS} | tee ${DEVFILE}/jenks
  echo -n "resolution "
  echo ${RESOLUTION} | tee ${DEVFILE}/resolution
  echo -n "rate "
  echo ${RATE} | tee ${DEVFILE}/rate
  echo -n "ztime "
  echo ${ZTIME} | tee ${DEVFILE}/ztime
  echo -n "skipback "
  echo ${SKIPBACK} | tee ${DEVFILE}/skipback
  echo -n "reach "
  echo ${REACH} | tee ${DEVFILE}/reach

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
SUBSYSTEM=="serio", DRIVERS=="psmouse", DEVPATH=="/sys/devices/platform/i8042/serio1/serio2", ATTR{sensitivity}="${SENSITIVITY}", ATTR{speed}="${SPEED}", ATTR{inertia}="${INERTIA}", ATTR{thresh}="${THRESH}", ATTR{upthresh}="${UPTHRESH}", ATTR{jenks}="${JENKS}", ATTR{resolution}="${RESOLUTION}", ATTR{rate}="${RATE}", ATTR{ztime}="${ZTIME}", ATTR{skipback}="${SKIPBACK}", ATTR{reach}="${REACH}"
EOF
  udevadm control --reload-rules
  udevadm trigger
elif [ "${OPTION}" = "find" ]; then
  echo ${DEVFILE}
else
  help
fi


