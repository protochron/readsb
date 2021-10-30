#!/usr/bin/dumb-init /bin/bash
set -e

out_dir="/var/run/readsb"
mkdir -p $out_dir

LAT=$LAT
LONG=$LONG
QUIET=${QUIET:=true}
STATS=${STATS:=true}
GAIN=${GAIN:="-10"} # 49.6
PPM=${PPM:=0}

if [ -z $LAT ]; then
  echo "need a latitude!"
  exit 1
fi

if [ -z $LONG ]; then
  echo "need a longitutde!"
  exit 1
fi

# Some values from https://github.com/Mictronics/readsb/blob/master/debian/readsb.default, which differ from the built-in defaults
set -- readsb \
  --gain="${GAIN}" \
  --lat="${LAT}" \
  --lon="${LONG}" \
  --device-type="rtlsdr" \
  --dcfilter \
  --json-location-accuracy=2 \
  --net \
  --modeac \
  --ppm="${PPM}" \
  --net-heartbeat=60 \
  --net-ro-size=1200 \
  --net-ro-interval=0.1 \
  --fix

if [ ! -z "$INTERACTIVE" ] ; then
  set -- "$@" --interactive
else
  set -- "$@" --write-json="$out_dir"

  if [ "${QUIET}" = "true" ]; then
    set -- "$@" --quiet
  fi
fi

if [ "${STATS}" = "true" ]; then
  set -- "$@" --stats-every=3600
fi

echo "$@"
exec "$@"
