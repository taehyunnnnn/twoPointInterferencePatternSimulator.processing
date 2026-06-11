SKETCH_NAME := TWO_POINT_INTERFERENCE_PATTERN_SIMULATOR
SKETCH_DIR  := $(shell pwd)

.PHONY: run open

run:
	@if command -v processing-java >/dev/null 2>&1; then \
		processing-java --sketch="$(SKETCH_DIR)" --run; \
	else \
		open -a Processing "$(SKETCH_DIR)/$(SKETCH_NAME).pde"; \
		echo "→ Processing IDE opened — click ▶ to run, then press Enter on the title screen"; \
	fi

open:
	open -a Processing "$(SKETCH_DIR)/$(SKETCH_NAME).pde"
