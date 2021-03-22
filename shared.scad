module stadium(width, length) {
    hull() {
        translate([(width-length)/2, 0, 0]) circle(d=min(width, length));
        translate([-(width-length)/2, 0, 0]) circle(d=min(width, length));
    }
}
