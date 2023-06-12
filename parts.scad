
module cylindricalheadscrew(head_diameter, tail_diameter) {
    linear_extrude(height = 100) 
    circle(d = tail_diameter);
    translate([0, 0, 50])
    linear_extrude(height = 50) 
    circle(d = head_diameter);
}

flatheadscrew(head_diameter = 13, tail_diameter = 10);
