const params = new URLSearchParams(window.location.search);

var numpaths = 1;
if (params.has("paths")) {
    numpaths = parseFloat(params.get("paths")) ?? 1;
}

var fast = false;
if (params.has("fast")) {
    fast = true;
}

let W = window.innerWidth;
let H = window.innerHeight;
let hscreenprop = 0.9;
let vscreenprop = 0.25;

let traces = [];

let colors = [];

function setup() {
    createCanvas(W, H);
    frameRate(60);

    for (let j = 0; j < numpaths; j++) {
        traces[j] = [0];
        
        colors[j] = [];
        colors[j][0] = Math.floor(Math.random() * 100 + 155);
        colors[j][1] = Math.floor(Math.random() * 100 + 155);
        colors[j][2] = Math.floor(Math.random() * 100 + 155);
    }

    colors[numpaths-1] = [0,0,0];
}

function drawPath(trace, color) {

    t = trace.length;
    dx = W * hscreenprop / t; 
    dy = H * vscreenprop / Math.sqrt(t);

    strokeWeight(3);
    stroke(color[0], color[1], color[2]);
    
    for (let j = 1; j < t; j++) {
        line(
            (j-1)*dx,
            H/2 + trace[j-1]*dy,
            j*dx,
            H/2 + trace[j]*dy
        )
    }
}

function draw() {
    background(255);

    var t = traces[0].length;
    var numsteps = 1;

    if (fast) {
        var poissonmean = 0.001*t + 1;
        var L = Math.exp(-poissonmean);
        var p = 1.0;
        var k = 0;
        
        do {
            k++;
            p *= Math.random();
        } while (p > L);
        
        var numsteps = k;
    }

    for(let i = 0; i < numsteps; i++) {
        for(let j = 0; j < numpaths; j++) {
            var xi = Math.random() < 0.5 ? -1 : 1;
            var si = traces[j][traces[j].length - 1];
            traces[j].push(si+xi);
        }
    }
    
    for (let j = 0; j < numpaths; j++) {
        drawPath(traces[j], colors[j]);
    }
}