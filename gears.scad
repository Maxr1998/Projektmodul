use <PolyGear/PolyGear.scad>;

// Render/quality params
default_fn = 900; // the quality to render at
tooth_fn = 36; // the quality to render the teeth at
spacing = 0.2; // a spacing value used in various places, matches the accuracy of the printer
stacked = false; // whether to stack the gears (for the preview) to space them out (for the final print)

// Model params
num_gears = 3;
num_teeth = 24;
rail_radius = 9.6;
rail_width = 1.8;
rail_thickness = 0.6;
gear_thickness = 3;
shaft_initial_radius = 2.8;
shaft_wall_thickness = 1.2;
shaft_base_height = 10;
shaft_extent = 3; // how far a shaft extends another one enclosing it

module __Customizer_Limit__() {} // Only variables until this line are customizable

module gear(shaft_inner_radius, shaft_wall_thickness, shaft_height) {
  difference() {
    union() {
      translate([0, 0, gear_thickness / 2]) {
        spur_gear(n = num_teeth, m = 1, z = gear_thickness, $fn = tooth_fn);
      }

      // Rail
      translate([0, 0, gear_thickness]) {
        difference() {
          cylinder(r = rail_radius, h = rail_thickness, $fn = default_fn);
          cylinder(r = rail_radius - rail_width, h = rail_thickness + 1, $fn = default_fn);
        }
      }

      // Shaft
      cylinder(r = shaft_inner_radius + shaft_wall_thickness, h = shaft_height, $fn = default_fn);
    }
    // Shaft hole
    translate([0, 0, - 0.1]) {
      cylinder(r = shaft_inner_radius, h = shaft_height + 0.2, $fn = default_fn);
    }
  }
}

module gear_instance(i) {
  rem = (num_gears - i);
  shaft_inner_radius = shaft_initial_radius + rem * (shaft_wall_thickness + spacing);
  shaft_height = shaft_base_height + i * (gear_thickness + rail_thickness + spacing + shaft_extent);

  color([i / num_gears, i / num_gears, i / num_gears]) {
    gear(shaft_inner_radius, shaft_wall_thickness, shaft_height);
  }
}

if (is_undef(instance)) {
  max_radius = 64; // used for spacing the gears apart
  start_xoffset = max_radius - (max_radius * num_gears);
  for (i = [1:num_gears]) {
    rem = (num_gears - i);
    zoffset = stacked ? rem * (gear_thickness + rail_thickness + spacing) : 0;
    translate([stacked ? 0: (start_xoffset + max_radius * 2 * (i - 1)), 0, zoffset]) {
      gear_instance(i);
    }
  }
} else {
  gear_instance(instance);
}