
module showPoints(points, size=0.02, use_sphere = true) {
    if(use_sphere == false) {
        for (c = points) translate(c) cube(size, center=true);
    }
    if(use_sphere == true) {
        for (c = points) translate(c) sphere(r = size, $fn = 10);
    }
}

// return point along curve at position "t" in range [0,1]
// use ctlPts[index] as the first control point
// Bezier curve has order == n
function BezierPoint(ctlPts, t, n, index=0) = (n > 1) ? 
    _BezierPoint([for (i = [index:index+n-1]) ctlPts[i] + t * (ctlPts[i+1] - ctlPts[i])], t, n-1) :
    ctlPts[index] + t * (ctlPts[index+1] - ctlPts[index]);

// slightly optimized version takes less parameters
function _BezierPoint(ctlPts, t, n) = (n > 1) ? 
    _BezierPoint([for (i = [0:n-1]) ctlPts[i] + t * (ctlPts[i+1] - ctlPts[i])], t, n-1) :
    ctlPts[0] + t * (ctlPts[1] - ctlPts[0]);

// n sets the order of the Bezier curves that will be stitched together
// if no parameter n is given, points will be generated for a single curve of order == len(ctlPts) - 1
// Note: $fn is number of points *per segment*, not over the entire path.
function BezierPath(ctlPts, n, index=0) = 
    let (
        l1 = $fn > 3 ? $fn : 200,
        l2 = len(ctlPts),
        n = (n == undef || n > l2-1) ? l2 - 1 : n
    )
    //assert(n > 0)
    [for (segment = [index:n:l2-1-n], i = [0:l1-1])
        BezierPoint(ctlPts, i / l1, n, segment), ctlPts[l2-1]];

