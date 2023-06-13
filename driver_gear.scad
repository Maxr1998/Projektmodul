use <PolyGear/PolyGear.scad>;

// Render/quality params
default_fn = 900; // the quality to render at
tooth_fn = 36; // the quality to render the teeth at

// Model params
instance = 1;

num_teeth = 24;
gear_thickness = 1.8;
gear_offset = 0.6; // a default offset to center the driver gear within the driven gear

shaft_radius = 5;
mount_radius = 2.5;
mount_height = 6;

driven_gear_thickness = 3.6;

module __Customizer_Limit__() {} // Only variables until this line are customizable

e = 0.01; // epsilon
shaft_height = gear_thickness + gear_offset + (instance - 1) * driven_gear_thickness;

module gear() {
  translate([0, 0, gear_thickness / 2]) {
    spur_gear(n = num_teeth, m = 1, z = gear_thickness, $fn = tooth_fn);
  }
}

module mounting_shaft() {
  cylinder(r = shaft_radius, h = shaft_height, $fn = default_fn);
}

module mount_cutout() {
  translate([0, 0, - mount_height + e]) {
    intersection() {
      cylinder(r = mount_radius, h = mount_height, $fn = default_fn);

      translate([- 3 / 2, - mount_radius, 0]) {
        cube([3, mount_radius * 2, mount_height]);
      }
    }
  }
}



difference() {
  union() {
    gear();
    mounting_shaft();
  }
  translate([0, 0, shaft_height]) {
    mount_cutout();
  }
}