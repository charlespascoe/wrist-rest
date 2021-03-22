include <shared.scad>;
include <m3.scad>;

$fn=200;

/* Recommented print settings:
 * Layer height: 0.2mm
 */

module collar(internal_plate_width, internal_plate_length, shell_height, internal_plate_thickness=3, material_thickness=1.5, wall_thickness=3) {
    tolerance = 0.2;

    bolt_height = 5;
    height = shell_height - wall_thickness * 2*material_thickness - internal_plate_thickness - 1;

    width = internal_plate_width + material_thickness*2 - tolerance;
    length = internal_plate_length + material_thickness*2 - tolerance;
    /* total_thickness = 2*wall_thickness + 2*material_thickness + internal_plate_thickness; */
    /* inner_groove_thickness = wall_thickness + 2*material_thickness + internal_plate_thickness; */

    internal_width = width - 2*wall_thickness - 2*m3_bolt_recess_depth;

    difference() {
        // Collar
        /* linear_extrude(height=2) */
        linear_extrude(height=height)
        difference() {
            stadium(length, width);

            offset(r=-wall_thickness-m3_bolt_recess_depth)
            stadium(length, width);
        };

        // Cutouts for bolts

        bolt_tolerance=1;
        bolt_displacement = abs(internal_plate_length - internal_plate_width) / 2 - 8;

        translate([bolt_displacement, -internal_width/2 - m3_bolt_recess_depth, bolt_height])
        rotate([-90, 0, 0])
        m3_bolt_recess_cutout(tolerance=bolt_tolerance, $fn=6);

        translate([-bolt_displacement, -internal_width/2 - m3_bolt_recess_depth, bolt_height])
        rotate([-90, 0, 0])
        m3_bolt_recess_cutout(tolerance=bolt_tolerance, $fn=6);

        translate([bolt_displacement, internal_width/2 + m3_bolt_recess_depth, bolt_height])
        rotate([90, 0, 0])
        m3_bolt_recess_cutout(tolerance=bolt_tolerance, $fn=6);

        translate([-bolt_displacement, internal_width/2 + m3_bolt_recess_depth, bolt_height])
        rotate([90, 0, 0])
        m3_bolt_recess_cutout(tolerance=bolt_tolerance, $fn=6);

    };
};

collar(60, 150, 28-2);
