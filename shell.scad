include <shared.scad>;
include <m3-test.scad>;

/* Recommended print settings:
 * Layer height: 0.15mm
 */

// An offset to prevent artifacts in preview mode - disable before rendering
// and exporting

/* preview_offset = 0.01; */
preview_offset = 0;
$fn=200;


module bolt_slot(wall_thickness) {
    tolerance=0.6;
    slot_length=12;

    translate([0, -wall_thickness, 0])
    rotate([0, 180, 0])
    rotate([-90, 0, 0])
    m3_cutout(nut_slot_length=slot_length, tolerance=tolerance, $fn=6);

        translate([0, 5-wall_thickness, slot_length - (m3_nut_width_point - tolerance)/2])
    cube([m3_nut_width + tolerance, 10, m3_nut_width_point + tolerance], center=true);
}

/* !difference() { */
/*     translate([0, 0, 5]) cube([10, 10, 10], center=true); */
/*     translate([0, 0, 5]) rotate([-90, 0, 0]) m3_bold_recess_cutout($fn=6, tolerance=1.2); */
/* } */

module skirt(
        internal_plate_width,
        internal_plate_length,
        height,
        wall_thickness=3,
        material_thickness=1.5,
        bottom_scale=1.1,
) {
    difference() {
        // Base - main shape
        minkowski() {
            linear_extrude(height=height, scale=bottom_scale)
            stadium(internal_plate_width + 2*material_thickness, internal_plate_length + 2*material_thickness);

            sphere(r=wall_thickness+2);
        }

        // Trim excess from top and bottom

        cutoff_width = max(internal_plate_width, internal_plate_length)*bottom_scale*1.5;
        cutoff_length = min(internal_plate_width, internal_plate_length)*bottom_scale*1.5;

        translate([0, 0, -wall_thickness + preview_offset])
        cube([
            cutoff_width,
            cutoff_length,
            2*wall_thickness,
        ], center=true);

        translate([0, 0, height + wall_thickness - preview_offset])
        cube([
            cutoff_width,
            cutoff_length,
            2*wall_thickness,
        ], center=true);

        // Subtract internal shape
        union() {
            difference() {
                // Base shape; allows 3mm walls all the way around. Cutting out of
                // this increases the material in the shell
                linear_extrude(height=height)
                stadium(internal_plate_width + 2*material_thickness, internal_plate_length + 2*material_thickness);

                // Flat-sided recess near the top for the collar to fit in
                /* linear_extrude(height=20) difference() { */
                /*     offset(delta=40) */
                /*     stadium(internal_plate_width + 2*material_thickness, internal_plate_length + 2*material_thickness); */

                /*     stadium(internal_plate_width + 2*material_thickness, internal_plate_length + 2*material_thickness); */

                /* }; */

                // A lip at the very top - smaller than the internal plate so that
                // the internal plate is pushed against it
                linear_extrude(height=wall_thickness) difference() {
                    offset(delta=40)
                    stadium(internal_plate_width - 2*wall_thickness, internal_plate_length - 2*wall_thickness);

                    stadium(internal_plate_width - 2*wall_thickness, internal_plate_length - 2*wall_thickness);

                };
            };

            bolt_height=height-5; // mm from the print bed

            translate([-internal_plate_length/4, internal_plate_width/2 + material_thickness, bolt_height])
            rotate([0, 180, 180])
            bolt_slot(wall_thickness);

            translate([internal_plate_length/4, internal_plate_width/2 + material_thickness, bolt_height])
            rotate([0, 180, 180])
            bolt_slot(wall_thickness);

            translate([internal_plate_length/4, -(internal_plate_width/2 + material_thickness), bolt_height])
            rotate([0, 180, 0])
            bolt_slot(wall_thickness);

            translate([-internal_plate_length/4, -(internal_plate_width/2 + material_thickness), bolt_height])
            rotate([0, 180, 0])
            bolt_slot(wall_thickness);
        };
    }
}



/* module nut_cutout() { */
/*     m3_cutout(); */
/*     translate([-5, -5, 3]) cube([10, 10, 40]); */
/*     translate([-5, 5, -5]) cube([10, 10, 50]); */
/* } */

/* $fn=200; */

// 28mm in total, minus rubber foot height of 2mm
skirt(60, 150, 28-2, bottom_scale=1.2);

// NOTE: Use 11.1mm bolts
