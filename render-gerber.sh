#!/bin/bash
# https://github.com/linalinn/kicad-render/blob/main/render-pcb.sh

set -e

help() {
    echo "Convert .kicad_pcb file to gerber"
    echo
    echo "Syntax: render-pcb.sh [-f|o|a|h]"
    echo "options:"
    echo "f     Path to .kicad_pcb file"
    echo "o     Directory where the images the animation should be written to."
    echo "v     Print program version"
    echo "h     Print this Help."
    echo
    exit
}

extract_project_name() {
  echo "$1" | rev | cut -d '/' -f 1 | rev | sed -e "s/.kicad_pcb//g"
}

extract_output_path() {
  echo "$1" | sed -e 's/[^\/]*\.kicad_pcb//g'
}

while getopts :f:o:p:a:b:z:hv option
do
    case "${option}" in
        f) kicad_pcb=${OPTARG};;
        o) output_path=${OPTARG};;
        p) filename_prefix=${OPTARG};;
        z) zoom=${OPTARG};;
        h) help;;
        v) echo "IMAGE version: ${VERSION:-none}" && exit;;
        \?)
            echo "Error: -${OPTARG} is invalid option"
            exit;
    esac
done

if [[ -z "$kicad_pcb" ]]; then
    help
fi

if [[ -z "$output_path" ]]; then
    path=$(extract_output_path "$2")
    extracted_project_name=$(extract_project_name "$2")
    name="${filename_prefix:-$extracted_project_name}"
    echo "name: $name"
    echo "path: $path"
    output_path="$path"
    output_gerber_dir="${path}gerber"
    echo "output_gerber_dir: $output_gerber_dir"
else
    if [[ -n "$filename_prefix" ]]; then
        output_gerber_dir="$output_path/${filename_prefix}_gerber"
    else
        output_gerber_dir="$output_path/gerber"
    fi
fi


KICAD_CLI=$(which kicad-cli || which kicad-cli-nightly)

echo "$output_path"

mkdir -p "$output_path"

echo "export gerber"
$KICAD_CLI pcb export gerbers --use-drill-file-origin -o "$output_gerber_dir" $KICAD_CLI_OPTIONAL_ARGS "$kicad_pcb"

ls "$output_path"
