let dt = 1/512;
let minTicks = 8;

let framesPerDouble = 60;
let doubleCounter = 0;

let W = window.innerWidth;
let H = window.innerHeight;
let unit;

let posB = [0];
let negB = [0];

let parity = 0;

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
    
    for (let j = 1; j < B.length; j++) {
        if (j % 2 == 0) {
            newB[j] = Math.sqrt(2) * B[Math.floor(j/2)];
        } else {
            newB[j] = Math.sqrt(2) * B[Math.floor(j/2)] + gaussianRandom((B[Math.floor(j/2)+1]-B[Math.floor(j/2)])/2, Math.sqrt(dt/2));
        }
    }
    
    return newB;
}

function setup() {
    createCanvas(W, H);
    unit = min(W,H) / minTicks;
    for (let j = 1; j < W/(2 * unit * dt); j++) {
        posB[j] = posB[j-1] + gaussianRandom(0, Math.sqrt(dt));
        negB[j] = negB[j-1] + gaussianRandom(0, Math.sqrt(dt));
    }
    frameRate(60);
}

function drawPath(B,lambda,scale,negate=false) {
    let epsilon = negate ? -1 : 1;

    strokeWeight(3);
    stroke('black');
    
    for (let j = 1; j < B.length/2; j++) {
        line(
            W/2 + epsilon*(2*(j-1))*dt*scale*unit,
            H/2 + B[2*(j-1)]*Math.sqrt(scale)*unit,
            W/2 + epsilon*(2*j-1)*dt*scale*unit,
            H/2 + lambda * B[2*j-1]*Math.sqrt(scale)*unit + (1-lambda) * (B[2*(j-1)]+B[2*j])*Math.sqrt(scale)*unit/2
        )
        line(
            W/2 + epsilon*(2*j-1)*dt*scale*unit,
            H/2 + lambda * B[2*j-1]*Math.sqrt(scale)*unit + (1-lambda) * (B[2*(j-1)]+B[2*j])*Math.sqrt(scale)*unit/2,
            W/2 + epsilon*2*j*dt*scale*unit,
            H/2 + B[2*j]*Math.sqrt(scale)*unit
        )
    }
}

function drawTicks(lambda, scale) {
    strokeWeight(1);
    stroke('gray');
    
    line(-5,H/2,W+5,H/2)
    line(W/2,-5,W/2,H+5)

    let vnum = H/(2*unit);
    let hnum = W/(2*unit);
    
    for (let j = 1; j < vnum; j++) {
        line(W/2-10, H/2 + j*unit*Math.sqrt(scale), W/2+10, H/2 + j*unit*Math.sqrt(scale));
        line(W/2-10, H/2 - j*unit*Math.sqrt(scale), W/2+10, H/2 - j*unit*Math.sqrt(scale));

        line(
            W/2 - 5*(lambda+parity),
            H/2 + (j - 1/2)*unit*Math.sqrt(scale),
            W/2 + 5*(lambda+parity),
            H/2 + (j - 1/2)*unit*Math.sqrt(scale)
        );
        line(
            W/2 - 5*(lambda+parity),
            H/2 - (j - 1/2)*unit*Math.sqrt(scale),
            W/2 + 5*(lambda+parity),
            H/2 - (j - 1/2)*unit*Math.sqrt(scale)
        );
    }

    for (let j = 1; j < hnum; j++) {
        line(W/2 + j*unit*scale, H/2-10, W/2 + j*unit*scale, H/2+10);
        line(W/2 - j*unit*scale, H/2-10, W/2 - j*unit*scale, H/2+10);

        line(
            W/2 + (j - 1/4)*unit*scale,
            H/2 - 5*(lambda+parity),
            W/2 + (j - 1/4)*unit*scale,
            H/2 + 5*(lambda+parity)
        )
        line(
            W/2 + (j - 3/4)*unit*scale,
            H/2 - 5*(lambda+parity),
            W/2 + (j - 3/4)*unit*scale,
            H/2 + 5*(lambda+parity)
        )
        line(
            W/2 + (j - 1/2)*unit*scale,
            H/2 - 5*(lambda+parity),
            W/2 + (j - 1/2)*unit*scale,
            H/2 + 5*(lambda+parity)
        )

        line(
            W/2 - (j - 1/4)*unit*scale,
            H/2 - 5*(lambda+parity),
            W/2 - (j - 1/4)*unit*scale,
            H/2 + 5*(lambda+parity)
        )
        line(
            W/2 - (j - 3/4)*unit*scale,
            H/2 - 5*(lambda+parity),
            W/2 - (j - 3/4)*unit*scale,
            H/2 + 5*(lambda+parity)
        )
        line(
            W/2 - (j - 1/2)*unit*scale,
            H/2 - 5*(lambda+parity),
            W/2 - (j - 1/2)*unit*scale,
            H/2 + 5*(lambda+parity)
        )
    }
}

function draw() {
    background(255);
    
    let lambda = doubleCounter/framesPerDouble;
    let twotol = Math.pow(2,lambda);

    drawTicks(lambda, twotol*Math.pow(2,parity));
    
    drawPath(posB, lambda, twotol);
    drawPath(negB, lambda, twotol,negate=true);
    
    doubleCounter += 1;
    
    if (doubleCounter >= framesPerDouble) {
        doubleCounter = 0;
        
        posB = resample(posB);
        negB = resample(negB);

        parity = 1-parity;
    }
}