#!/usr/bin/env bash
set -e

help() {
    echo "Convert .kicad_sch file to pdf and svg"
    echo
    echo "Syntax: render-sch.sh [-f|o|a|h]"
    echo "options:"
    echo "f     Path to .kicad_sch file"
    echo "o     Directory where the images the animation should be written to."
    echo "v     Print program version"
    echo "h     Print this Help."
    echo
    exit
}

extract_project_name() {
  echo "$1" | rev | cut -d '/' -f 1 | rev | sed -e "s/.kicad_sch//g"
}

extract_output_path() {
  echo "$1" | sed -e 's/[^\/]*\.kicad_sch//g'
}

background="opaque"

while getopts :f:o:p:a:b:z:hv option
do
    case "${option}" in
        f) kicad_sch=${OPTARG};;
        o) output_path=${OPTARG};;
        h) help;;
        v) echo "IMAGE version: ${VERSION:-none}" && exit;;
        \?)
            echo "Error: -${OPTARG} is invalid option"
            exit;
    esac
done

if [[ -z "$kicad_sch" ]]; then
    help
fi


if [[ -z "$output_path" ]]; then
    path=$(extract_output_path "$2")
    extracted_project_name=$(extract_project_name "$2")
    name="${filename_prefix:-$extracted_project_name}"
    echo "name: $name"
    echo "path: $path"
    output_path="$path"
    output_schematic_pdf="${path}${name}.pdf"
    echo "output_schematic_pdf: $output_schematic_pdf"
    output_schematic_svg_dir="${path}/"
    echo "output_schematic_svg_dir: $output_schematic_svg_dir"
else
    if [[ -n "$filename_prefix" ]]; then
        output_schematic_pdf="$output_path/${filename_prefix}.pdf"
        output_schematic_svg_dir="$output_path/"
    else
        output_schematic_pdf="$output_path/schematic.pdf"
        output_schematic_svg_dir="$output_path/"
    fi
fi


KICAD_CLI=$(which kicad-cli || which kicad-cli-nightly)

echo "$output_path"

mkdir -p "$output_path"

echo "Rendering schematic PDF"
$KICAD_CLI sch export pdf -o "$output_schematic_pdf" "$kicad_sch"

echo "Rendering schematic SVG"
$KICAD_CLI sch export svg -o "$output_schematic_svg_dir" "$kicad_sch"

ls "$output_path"
