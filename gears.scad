// Render/quality params
fn = 1000; // the quality to render at
spacing = 0.2; // a spacing value used in various places, matches the accuracy of the printer
stacked = false; // whether to stack the gears (for the preview) to space them out (for the final print)

// Model params
num_gears = 3;
max_radius = 30;
max_num_teeth = 68;
plate_thickness = 1.6;
plate_spacing = 0.4;
shaft_initial_radius = 2.8;
shaft_wall_thickness = 1.2;
shaft_base_height = 30;
shaft_extent = 3; // how far a shaft extends another one enclosing it
tooth_length = 3;
tooth_width = 1.4;
tooth_height = 1.4;
tooth_spacing = 0.6; // how much space is left between the teeth of two gears

module __Customizer_Limit__() {} // Only variables until this line are customizable

// Constants
pi = 3.141592653589793238462643383279502884197169399375105820974944592307816406286;

module gear_tooth(length, width, height, $fn) {
  translate([0, - width / 2, 0]) {
    rotate([90, 0, 90]) {
      linear_extrude(length) {
        points = [for (a = [0 : 1 / $fn : 1]) [a * width, height * sin(a * 180)]];
        polygon(points = points, $fn = $fn);
      }
    }
  }
}

module gear(radius, num_teeth, thickness,
shaft_inner_radius, shaft_wall_thickness, shaft_height,
tooth_base_height, tooth_length, tooth_width, tooth_height) {
  difference() {
    union() {
      // Base
      cylinder(r = radius, h = thickness, $fn = fn);

      // Base for teeth
      linear_extrude(thickness + tooth_base_height) {
        difference() {
          circle(r = radius, $fn = fn);
          circle(r = radius - tooth_length, $fn = fn);
        }
      }

      // Teeth
      for (i = [0:num_teeth - 1]) {
        rotate([0, 0, i * (360 / num_teeth)]) {
          translate([radius - tooth_length, - tooth_width / 2, thickness + tooth_base_height]) {
            gear_tooth(tooth_length, tooth_width, tooth_height, fn);
          }
        }
      }

      // Shaft
      cylinder(r = shaft_inner_radius + shaft_wall_thickness, h = shaft_height, $fn = fn);
    }
    // Shaft hole
    translate([0, 0, - 0.1]) {
      cylinder(r = shaft_inner_radius, h = shaft_height + 0.2, $fn = fn);
    }
  }
}

max_circumference = 2 * pi * max_radius;
tooth_pitch = max_circumference / max_num_teeth;
start_xoffset = max_radius - (max_radius * num_gears);

module gear_instance(i) {
  rem = (num_gears - i);
  radius = max_radius - rem * (tooth_length + tooth_spacing);
  circumference = 2 * pi * radius;
  num_teeth = floor(circumference / tooth_pitch);
  shaft_inner_radius = shaft_initial_radius + rem * (shaft_wall_thickness + spacing);
  shaft_height = shaft_base_height + i * (plate_thickness + spacing + shaft_extent);
  tooth_base_height = (plate_thickness + plate_spacing) * (i - 1);

  color([i / num_gears, i / num_gears, i / num_gears]) {
    gear(radius, num_teeth, plate_thickness,
    shaft_inner_radius, shaft_wall_thickness, shaft_height,
    tooth_base_height, tooth_length, tooth_width, tooth_height);
  }
}

if (is_undef(instance)) {
  for (i = [1:num_gears]) {
    zoffset = stacked ? rem * (plate_thickness + plate_spacing) : 0;
    translate([stacked ? 0: (start_xoffset + max_radius * 2 * (i - 1)), 0, zoffset]) {
      gear_instance(i);
    }
  }
} else {
  gear_instance(instance);
}