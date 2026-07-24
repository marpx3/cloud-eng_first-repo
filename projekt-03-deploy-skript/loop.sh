#!/bin/bash
set -euo pipefail

UMGEBUNGEN="dev test prod"

for env in $UMGEBUNGEN; do
  echo "Verarbeite Umgebung: $env"
done

for i in {1..5}; do
  echo "Versuch $i von 5"
  sleep 1
done
