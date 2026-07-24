#!/bin/bash

if [ -z "$1" ]; then
  echo "Fehler: kein Umgebungsname übergeben." >&2
  echo "Aufruf: $0 <umgebungsname>" >&2
  exit 1
fi

ENV_NAME="$1"
echo "Baue Umgebung: $ENV_NAME"
exit 0
