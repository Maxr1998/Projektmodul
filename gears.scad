include <roundedcube.scad>

fn = 1000; // the quality to render at
spacing = 0.2; // a spacing value used in various places, matches the accuracy of the printer
stacked = 0; // 1 to stack the gears (for the preview) or 0 to space them out (for the final print)
pi = 3.141592653589793238462643383279502884197169399375105820974944592307816406286;

module gear_tooth(length, width, height) {
  roundedcube(size = [length, width, height], apply_to = "zmax");
}

module gear(radius, num_teeth, thickness,
shaft_inner_radius, shaft_wall_thickness, shaft_height,
tooth_base_height, tooth_length, tooth_width, tooth_height) {
  difference() {
    union() {
      // Base
      cylinder(r = radius, h = thickness, $fn = fn);

      // Base for teeth
      linear_extrude(tooth_base_height) {
        difference() {
          circle(r = radius, $fn = fn);
          circle(r = radius - tooth_length, $fn = fn);
        }
      }

      // Teeth
      for (i = [0:num_teeth - 1]) {
        rotate([0, 0, i * (360 / num_teeth)]) {
          translate([radius - tooth_length, 0, tooth_base_height]) {
            gear_tooth(tooth_length, tooth_width, tooth_height);
          }
        }
      }

      // Shaft
      cylinder(r = shaft_inner_radius + shaft_wall_thickness, h = shaft_height, $fn = fn);
    }
    // Shaft hole
    translate([0, 0, - 0.1]) {
      cylinder(r = shaft_inner_radius + spacing, h = shaft_height + 0.2, $fn = fn);
    }
  }
}

num_gears = 3;

max_num_teeth = 64;
plate_thickness = 1;
shaft_height = 30;
shaft_wall_thickness = 1;
tooth_length = 3;
tooth_width = 1.4;
tooth_height = 1.6;

max_radius = 20 + num_gears * (tooth_length + spacing * 3);
max_circumference = 2 * pi * max_radius;
tooth_pitch = max_circumference / max_num_teeth;
start_xoffset = max_radius - (max_radius * num_gears);
for (i = [1:num_gears]) {
  radius = 20 + i * (tooth_length + spacing * 3);
  circumference = 2 * pi * radius;
  num_teeth = floor(circumference / tooth_pitch);
  shaft_inner_radius = 1 + i * shaft_wall_thickness;
  zoffset = stacked * (num_gears - i) * (plate_thickness + spacing);
  tooth_base_height = plate_thickness * i;

  translate([(1 - stacked) * (start_xoffset + max_radius * 2 * (i - 1)), 0, zoffset]) {
    gear(radius, num_teeth, plate_thickness,
    shaft_inner_radius, shaft_wall_thickness, shaft_height,
    tooth_base_height, tooth_length, tooth_width, tooth_height);
  }
}
