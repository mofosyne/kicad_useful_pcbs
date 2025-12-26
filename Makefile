SHELL := /usr/bin/env bash

.PHONY: all render render-one readme clean

# Default target
all: render readme

# Render every PCB in every folder
render:
	./render-each-folder.sh

# Render a single PCB:
render-one:
	@if [ -z "$(PCB)" ]; then \
		echo "Usage: make render-one PCB=path/to/file.kicad_pcb"; \
		exit 1; \
	fi
	./render-pcb.sh -f "$(PCB)"

# Generate README.md
readme:
	./render-readme.sh

# Optional cleanup
clean:
	find . -name "*_top.png" -delete
	find . -name "*_bottom.png" -delete
	find . -name "*.svg" -delete
	rm -f README.md
