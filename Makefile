SKETCH_NAME := TWO_POINT_INTERFERENCE_PATTERN_SIMULATOR
SKETCH_DIR  := $(shell pwd)

.PHONY: run open jar clean

run:
	@if command -v processing-java >/dev/null 2>&1; then \
		processing-java --sketch="$(SKETCH_DIR)" --run; \
	else \
		open -a Processing "$(SKETCH_DIR)/$(SKETCH_NAME).pde"; \
		echo "→ Processing IDE opened — click ▶ to run, then press Enter on the title screen"; \
	fi

open:
	open -a Processing "$(SKETCH_DIR)/$(SKETCH_NAME).pde"

jar:
	mkdir -p build
	javac -cp lib/core.jar source/$(SKETCH_NAME).java -d build/
	cd build && jar xf ../lib/core.jar
	echo "Main-Class: $(SKETCH_NAME)" > build/manifest.mf
	cd build && jar cfm ../$(SKETCH_NAME).jar manifest.mf .
	@echo "→ Built $(SKETCH_NAME).jar — run with: java -jar $(SKETCH_NAME).jar"

clean:
	rm -rf build $(SKETCH_NAME).jar
