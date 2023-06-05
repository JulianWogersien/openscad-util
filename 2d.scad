 
module Line(x1, y1, x2, y2, thickness, round = true)
{
    if (round == true) {
        hull()
        {
            translate([ x1, y1, 0 ]) circle(r = thickness);
            translate([ x2, y2, 0 ]) circle(r = thickness);
        }
    } else {
        hull()
        {
            translate([ x1, y1, 0 ]) square(thickness);
            translate([ x2, y2, 0 ]) square(thickness);
        }
    }
}

function DoLinesIntersect(p1, p2, p3, p4) =
    let(s1 = vec2sub(p2, p1),
        s2 = vec2sub(p4, p3),
        s = (-s1[1] * (p1[0] - p3[0]) + s1[0] * (p1[1] - p3[1])) /
            (-s2[0] * s1[1] + s1[0] * s2[1]),
        t = (s2[0] * [p1[1] - p3[1]] + s2[1] * (p1[0] - p3[0])) /
            (-s2[0] * s1[1] + s1[0] * s2[1]),
        cp = [ p1[0] + (t * s1[0]), p1[1] + (t * s1[1]) ]) s
                >= 0 &&
            s <= 1 && t >= 0 && t <= 1
        ? [ true, cp ]
        : [ false, cp ];

function DoCircleIntersect(x1, y1, x2, y2, r1, r2) =
    let(d = sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))) d <= r1 - r2
            || d <= r2 - r1 || d < r1 + r2
        ? true
        : false;
