GEARS=$(patsubst %,gear_%.gcode, 1 2 3)

all: $(GEARS)

gear_%.stl: gears.scad
	openscad -D instance=$* -m make -o $@ $<

.PRECIOUS: gear_%.stl # Keep stl files

gear_%.gcode: gear_%.stl
	prusa-slicer --load PrusaSlicer_cli_config.ini -g -o $@ $<