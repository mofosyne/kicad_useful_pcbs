set shell := ["bash", "-cu"]

default: render readme

# Render all PCBs
render:
    ./render-each-folder.sh

# Render one PCB
render-one pcb:
    ./render-pcb.sh -f "{{pcb}}"

# Generate README
readme:
    ./render-readme.sh

# Remove generated files
clean:
    find . -name "*_top.png" -delete
    find . -name "*_bottom.png" -delete
    find . -name "*.svg" -delete
    rm -f README.md

# Show what would be rendered (dry run)
list:
    find . -name "*.kicad_pcb"
