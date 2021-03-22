include <shared.scad>;

$fn=200;

/* Internval Plate */
module internal_plate(width, length, thickness=3) {
    linear_extrude(height=thickness) stadium(width, length);
}

internal_plate(60, 150);
