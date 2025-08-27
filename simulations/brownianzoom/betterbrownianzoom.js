let W = window.innerWidth;
let H = window.innerHeight;
let unit;

//let delta = min(W,H) / minTicks;
let sigma = 10; // Scale factor
let delta = 0.1; // Initial step size
let epsilon = 1/1024; // power of 2 or 4

let rho = Math.pow(2, epsilon);
let rhosquared = Math.pow(4, epsilon);

let xaxis = [0];
let yaxis = [0];
let posB = [0];
let negB = [0];

let parity = 0;
var tickIndex = 0;

// Standard Normal variate using Box-Muller transform.
function gaussianRandom(mean=0, stdev=1) {
    let u = 1 - Math.random(); //Converting [0,1) to (0,1)
    let v = Math.random();
    let z = Math.sqrt( -2.0 * Math.log( u ) ) * Math.cos( 2.0 * Math.PI * v );
    // Transform to the desired mean and standard deviation:
    return z * stdev + mean;
}

function resample(B) {
    newB = [0];
    
    for (let j = B.length - 1; j > 1; j--) {
        newB[j] = B[j-1] * rho;
    }

    newB[1] = gaussianRandom(rho * B[1] * (1 / rhosquared), sigma * Math.sqrt(delta * (rhosquared - 1) / rhosquared));
    
    return newB;
}

function setup() {
    createCanvas(W, H);

    xaxis[1] = delta;
    yaxis[1] = Math.sqrt(delta);

    posB[1] = sigma * gaussianRandom(0, Math.sqrt(delta));
    negB[1] = sigma * gaussianRandom(0, Math.sqrt(delta));

    for (let j = 2; j < 4*2048; j++) {
        xaxis[j] = xaxis[j-1] * rhosquared;

        posB[j] = posB[j-1] + sigma * gaussianRandom(0, Math.sqrt(xaxis[j] - xaxis[j-1]));
        negB[j] = negB[j-1] + sigma * gaussianRandom(0, Math.sqrt(xaxis[j] - xaxis[j-1]));
    }
    for (let j = 2; j < 4*4096; j++) {
        yaxis[j] = yaxis[j-1] * rho;
    }

    frameRate(60);
}

function drawPath(B, negate=false) {
    strokeWeight(3);
    stroke('black');

    signum = negate ? -1 : 1;

    for (let j = 1; j < B.length; j++) {
        strokeWeight(j*.0005 + 0.05)
        line(
            W/2 + signum * xaxis[j-1],
            H/2 + B[j-1],
            W/2 + signum * xaxis[j],
            H/2 + B[j]
        )
    }

}

function drawTicks() {
    strokeWeight(1);
    stroke('gray');

    line(-5, H/2, W+5, H/2)
    line(W/2, -5, W/2, H+5)

    for (let j = 1; j < xaxis.length; j++) {
        if (j % 40 == tickIndex % 40) {
            let ticklength = min(10, 0.03*xaxis[j])
            line(
                W/2 + xaxis[j],
                H/2 - ticklength,
                W/2 + xaxis[j],
                H/2 + ticklength
            )
            line(
                W/2 - xaxis[j],
                H/2 - ticklength,
                W/2 - xaxis[j],
                H/2 + ticklength
            )
        }
    }

    for (let j = 1; j < yaxis.length; j++) {
        if (j % 80 == tickIndex % 80) {
            let ticklength = min(10, 0.03*yaxis[j])
            line(
                W/2 - ticklength,
                H/2 + yaxis[j],
                W/2 + ticklength,
                H/2 + yaxis[j]
            )

            line(
                W/2 - ticklength,
                H/2 - yaxis[j],
                W/2 + ticklength,
                H/2 - yaxis[j]
            )
        }
    }

}

function draw() {
    background(255);

    drawTicks();

    drawPath(posB);
    drawPath(negB, negate=true);

    posB = resample(posB);
    negB = resample(negB);

    tickIndex += 1;
}