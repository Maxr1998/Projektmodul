GEARS=$(patsubst %,gear_%.gcode, 1 2 3)
DRIVER_GEARS=$(patsubst %,driver_gear_%.gcode, 1 2 3)

all: $(GEARS) $(DRIVER_GEARS)

gear_%.stl: gears.scad
	openscad -D instance=$* -m make -o $@ $<

driver_gear_%.stl: driver_gear.scad
	openscad -D instance=$* -m make -o $@ $<

%.gcode: %.stl
	prusa-slicer --load PrusaSlicer_cli_config.ini -g -o $@ $<

.PRECIOUS: gear_%.stl driver_gear_%.stl # Keep stl files