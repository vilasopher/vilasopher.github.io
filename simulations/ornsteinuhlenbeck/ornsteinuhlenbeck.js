let dt = 0.01;
let numpaths = 3;
let W = window.innerWidth;
let H = window.innerHeight;
let unit = H/6;
let maxpoints = 0.9 * W / (unit * dt)
let X = [];
let N = 0;
let colors = [];
let tickstart = 0;

// Standard Normal variate using Box-Muller transform.
function gaussianRandom(mean=0, stdev=1) {
    let u = 1 - Math.random(); //Converting [0,1) to (0,1)
    let v = Math.random();
    let z = Math.sqrt( -2.0 * Math.log( u ) ) * Math.cos( 2.0 * Math.PI * v );
    // Transform to the desired mean and standard deviation:
    return z * stdev + mean;
}

function setup() {
  createCanvas(W, H);
  frameRate(60);
  
  for (let j = 0; j < numpaths; j++) {
    X[j] = [];
    X[j][0] = gaussianRandom(0, Math.sqrt(0.5));
    
    colors[j] = [];
    colors[j][0] = Math.floor(Math.random() * 255);
    colors[j][1] = Math.floor(Math.random() * 255);
    colors[j][2] = Math.floor(Math.random() * 255);
  }
}

function draw() {
  background(255);
  
  stroke(0);
  for (let k = -2; k <= 2; k++) {
    strokeWeight(1);
    if (k==0) {
      strokeWeight(2);
    }
    line(-5, H/2 + k * unit, W+5, H/2 + k * unit); 
  }
  
  for (let k = 0; k <= W / unit + 1; k++) {
    strokeWeight(2);
    line(tickstart + k * unit, H/2 - 10, tickstart + k * unit, H/2 + 10);
  }

  if (N < maxpoints) {
    N += 1;
  } else {
    for (let j = 0; j < numpaths; j++) {
      for (let i = 1; i <= N; i++) {
        X[j][i-1] = X[j][i];
      }
    }
    tickstart -= dt * unit;
    if(tickstart < -5) {
      tickstart += unit;
    }
  }
  
  for (let j = 0; j < numpaths; j++) {
    X[j][N] = X[j][N-1] + gaussianRandom(0, Math.sqrt(dt)) - dt * X[j][N-1];
  }
  
  for (let j = 0; j < numpaths; j++) {
    stroke(colors[j][0], colors[j][1], colors[j][2]);
    strokeWeight(4);
    for (let i = 1; i <= N; i++) {
      line(dt*unit*(i-1)-5, H/2 + unit*X[j][i-1], dt*unit*i-5, H/2 + unit*X[j][i]);
    }
    strokeWeight(10)
    point(dt*unit*N-5, H/2 + unit*X[j][N]);
  }
}