
m3_tolerance = 0.2;

m3_nut_width = 5.4;
m3_nut_width_point = 6;
m3_nut_height = 2.5;
m3_bolt_head_diameter = 5.4;
m3_bolt_recess_depth = 3;

module m3_cutout(nut_slot_length=10, tolerance=0.2, extra_thread_recess=true) {
    union() {
        // Z axis is the bolt axis
        // Cutout for nut
        translate([-(m3_nut_width + tolerance)/2, -(m3_nut_width_point + tolerance)/2, -2.5]) cube([m3_nut_width + tolerance, (m3_nut_width_point + tolerance)/2 + nut_slot_length + tolerance, m3_nut_height + tolerance]);

        translate([-(m3_nut_width + tolerance)/2, -(3 + tolerance)/2, 0]) cube([m3_nut_width + tolerance, 3 + tolerance, 10]);

        // Recess for extra thread
        if (extra_thread_recess) {
            translate([0, 0, -4]) cylinder(d=3 + 2*tolerance, h=4);
        }
    }
}

module m3_bolt_recess_cutout(tolerance=0.2) {
    union() {
        translate([0, 0, -10])
        cylinder(d=m3_bolt_recess_depth + tolerance, h=11);

        cylinder(d=m3_bolt_head_diameter + tolerance, h=10);
    }
}

/* !m3_cutout(); */

/* $fn=100; */
/* difference() { */
/*     translate([-5, -5, 0]) cube([10, 10, 8]); */
/*     translate([0, 0, 5]) m3_cutout(); */
/* } */

/* translate([20, 0, 0]) difference() { */
/*     translate([-5, -5, 0]) cube([10, 10, 6]); */
/*     translate([0, 0, 3]) m3_bold_recess_cutout(); */
/* } */
