use<list.scad>

// rotates children around point
module RotateAroundPoint(x, z, y, pt) {
    translate(pt)
        rotate([x, y, z])
            translate(-pt)
                children();   
}

// calculates the height and width from aspect ration and diagonal size
function HeightWidthFromAspectDiag(aspect_ratio, diag_size) = let(height = diag_size / sqrt(aspect_ratio^2 + 1), width = sqrt((diag_size^2) - (height^2))) [width, height];

// randomizes given 3 part points slightly
function RandomizePointsSlightly(points, max = 1, min = -1) = let(rnums = [for(i = [0:len(points) - 1]) rands(min, max, len(points))[0]]) [for(point=[0:len(points) - 1]) [points[point][0] + rnums[point], points[point][1] + rnums[point], points[point][2] + rnums[point]]];

// determines if i is on a magnitude cycle
// this is used for AddSlightlyRandomizedPoints
function DetermineMagnitudeCycle(magnitude, i) = let(normal = i / magnitude) normal == floor(normal);

// adds slightly randomized points, how many points are added can be configured with magnitude which behaves like len(points) * magnitude
function AddSlightlyRandomizedPoints(points, max = 1, min = -1, magnitude = 2) = [for(i = [0:((len(points)) * magnitude) - 1]) !DetermineMagnitudeCycle(magnitude, i) ? [points[i / magnitude][0] + rands(min, max, 1)[0], points[i / magnitude][1] + rands(min, max, 1)[0], points[i / magnitude][2] + rands(min, max, 1)[0]] : points[i / magnitude]];

// linearly interpolates between both 2 dimensional points at given x
function LinearInterpolation(x0, y0, x1, y1, x) = (y0 * (x1 - x) + y1 * (x - x0)) / x1 - x0;

// attempts to linearly interpolate between 3 point coordinates
function LinearInterpolation3(p1, p2, x = 1, xstart = 0, xend = 2) = [LinearInterpolation(xstart, p1[0], xend, p2[0], x), LinearInterpolation(xstart, p1[1], xend, p2[1], x), LinearInterpolation(xstart, p1[2], xend, p2[2], x)];

// Returns in array with first element point 1 and last element point 2 and inbetween points that from point one approach point 2
function InterpolatePoints(point1, point2, magnitude, min = 0, max = 2) = [for(i = [0:magnitude + 2]) LinearInterpolation3(point1, point2, i, min, max)];

