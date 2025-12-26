#!/bin/bash

find . -name "*.kicad_pcb" -type f -print0 |
while IFS= read -r -d '' pcb; do
  ./render-pcb.sh -f "$pcb"
  ./render-gerber.sh -f "$pcb"
done

find . -name "*.kicad_sch" -type f -print0 |
while IFS= read -r -d '' sch; do
  ./render-sch.sh -f "$sch"
done
