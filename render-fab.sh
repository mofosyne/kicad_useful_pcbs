#!/usr/bin/env bash
set -e

help() {
    echo "Convert .kicad_pcb file to fab-ready Gerber ZIP"
    echo
    echo "Syntax: render-gerbers.sh -f board.kicad_pcb [-o outdir]"
    exit
}

extract_project_name() {
  basename "$1" .kicad_pcb
}

extract_output_path() {
  dirname "$1"
}

while getopts :f:o:hv option; do
    case "${option}" in
        f) kicad_pcb=${OPTARG};;
        o) output_path=${OPTARG};;
        h) help;;
        v) echo "version: ${VERSION:-none}" && exit;;
        \?) echo "Error: -${OPTARG} is invalid option"; exit 1;;
    esac
done

[[ -z "$kicad_pcb" ]] && help

# Defaults
if [[ -z "$output_path" ]]; then
    output_path=$(extract_output_path "$kicad_pcb")
fi

name=$(extract_project_name "$kicad_pcb")
gerber_dir="$output_path/gerbers"
zip_file="$output_path/${name}_fabrication.zip"

KICAD_CLI=$(which kicad-cli || which kicad-cli-nightly)

mkdir -p "$gerber_dir"

echo "Exporting Gerbers"

$KICAD_CLI pcb export gerbers \
  --use-drill-file-origin \
  -o "$gerber_dir" \
  "$kicad_pcb"

echo "Exporting drill files"
$KICAD_CLI pcb export drill \
  --format excellon \
  --map-format pdf \
  -o "$gerber_dir" \
  "$kicad_pcb"

echo "Creating ZIP: $zip_file"
(
  cd "$gerber_dir"
  zip -r "../$(basename "$zip_file")" .
)

echo "Delete Gerber Working Folder: $gerber_dir"
(
  rm -rf "$gerber_dir"
)

echo "Done ✔"
ls "$output_path"
