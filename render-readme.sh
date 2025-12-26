#!/usr/bin/env bash
set -e

OUT="README.md"

cat > "$OUT" <<'EOF'
# kicad_useful_pcbs
various small pcb boards that may be of use for various projects
EOF

echo "" >> "$OUT"

# Loop over directories
for dir in */; do
  dir="${dir%/}"

  # Skip hidden or non-project dirs if needed
  [ -d "$dir" ] || continue

  # Find a pcb file
  pcb=$(find "$dir" -maxdepth 1 -name "*.kicad_pcb" | head -n 1)
  [ -n "$pcb" ] || continue

  # Title formatting: snake_case → Title Case
  title=$(basename "$dir" | sed 's/_/ /g; s/\b\(.\)/\u\1/g')

  echo "## $title" >> "$OUT"
  echo "" >> "$OUT"

  for img in \
    "${dir}"/*_top.png \
    "${dir}"/*_bottom.png \
    "${dir}"/*.svg; do
    if [ -f "$img" ]; then
      echo "![]($img)" >> "$OUT"
      echo "" >> "$OUT"
    fi
  done

  schematic_pdf=$(find "$dir" -maxdepth 1 -name "*.pdf" | head -n 1)
  echo "- [schematic pdf](${schematic_pdf})" >> "$OUT"
  echo "" >> "$OUT"

  fabrication_file=$(find "$dir" -maxdepth 1 -name "*_fabrication.zip" | head -n 1)
  echo "- [fabrication gerber and drills files](${fabrication_file})" >> "$OUT"

done

echo "README.md generated ✔"
