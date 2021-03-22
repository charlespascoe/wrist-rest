include <shared.scad>;
include <m3.scad>;

/* Recommended print settings:
 * Layer height: 0.15mm
 */

$fn=200;

module bolt_slot(wall_thickness) {
    tolerance=0.4;

    translate([0, -wall_thickness, 0])
    rotate([0, 180, 0])
    rotate([-90, 0, 0])
    m3_cutout(tolerance=tolerance, $fn=6, extra_thread_recess=false);
}

module shell(
        internal_plate_width,
        internal_plate_length,
        height,
        wall_thickness=3,
        material_thickness=1.5,
        bottom_delta=14,
) {
    width = 2*wall_thickness + 2*material_thickness + internal_plate_width;
    length = 2*wall_thickness + 2*material_thickness + internal_plate_length;
    bottom_width = width + bottom_delta;
    bottom_length = length + bottom_delta;

    difference() {
        // Base - main shape

        linear_extrude(height=height, scale=[bottom_length/length, bottom_width/width])
        stadium(width, length);

        // Subtract internal shape
        union() {
            difference() {
                // Base shape; allows 3mm walls all the way around. Cutting out of
                // this increases the material in the shell
                // (The +0.2 to height and -0.1 translation are to avoid visual
                // artifacts in preview mode)
                translate([0, 0, -0.1])
                linear_extrude(height=height+0.2)
                stadium(internal_plate_width + 2*material_thickness, internal_plate_length + 2*material_thickness);

                // A lip at the very top - smaller than the internal plate so that
                // the internal plate is pushed against it
                linear_extrude(height=wall_thickness) difference() {
                    offset(delta=40)
                    stadium(internal_plate_width - 2*wall_thickness, internal_plate_length - 2*wall_thickness);

                    stadium(internal_plate_width - 2*wall_thickness, internal_plate_length - 2*wall_thickness);

                };
            };

            bolt_height = height - 6; // mm from the print bed
            bolt_displacement = abs(internal_plate_length - internal_plate_width) / 2 - 8;

            translate([bolt_displacement, internal_plate_width/2 + material_thickness, bolt_height])
            rotate([0, 0, 180])
            bolt_slot(wall_thickness);

            translate([-bolt_displacement, internal_plate_width/2 + material_thickness, bolt_height])
            rotate([0, 0, 180])
            bolt_slot(wall_thickness);

            translate([bolt_displacement, -(internal_plate_width/2 + material_thickness), bolt_height])
            bolt_slot(wall_thickness);

            translate([-bolt_displacement, -(internal_plate_width/2 + material_thickness), bolt_height])
            bolt_slot(wall_thickness);
        };
    }
}

// 28mm in total, minus rubber foot height of 2mm
shell(60, 150, 28-2);
