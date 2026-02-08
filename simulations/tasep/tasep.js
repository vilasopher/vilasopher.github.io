let W = window.innerWidth;
let H = window.innerHeight;

let particlesize = 10;
let numrealities = 5;
let numparticles = numrealities*Math.ceil(W/particlesize);
let spacingratio = 1.25;
let dy = particlesize * spacingratio;
let shiftframes = 240;

let rate = 0.05;

let particles = [];
let indices = [];

/* Randomize array in-place using Durstenfeld shuffle algorithm */
function shuffleArray(array) {
    for (var i = array.length - 1; i > 0; i--) {
        var j = Math.floor(Math.random() * (i + 1));
        var temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }
}

function setup() {
    createCanvas(W, H);
    frameRate(60);

    for (let i = 0; i < 2*numparticles; i++) {
        if (i < numparticles) {
            particles[i] = true;
        } else {
            particles[i] = false;
        }
        indices[i] = i;
    }

    currentycoord = H/2 - sumonleft() * dy;
}

function sumonleft() {
    count = 0;
    for (let i = 0; i < numparticles; i++) {
        if (particles[i]) {
            count += 1;
        } else {
            count -= 1;
        }
    }
    return count;
}

function xcoord(index) {
    return (index - numparticles) * particlesize * spacingratio + W/2;
}

let currentycoord = 3*H/5 - sumonleft() * dy;

function startingycoord() {
    let nextycoord = 3*H/5 - sumonleft() * dy;
    currentycoord += (nextycoord - currentycoord) / shiftframes;
    return currentycoord;
}

function drawPath() {
    stroke(0,0,0);
    strokeWeight(4);
    noFill();

    beginShape();

    ycoord = startingycoord();
    vertex(xcoord(-0.5), ycoord);

    for (let i = 0; i < 2*numparticles; i++) {
        ycoord += particles[i] ? dy : -dy;
        vertex(xcoord(i + 0.5), ycoord);
    }

    endShape();
}

function drawParticles() {
    strokeWeight(2);
    for (let i = 0; i < 2*numparticles; i++) {
        if (particles[i]) {
            fill(color('black'));
        } else {
            fill(color('white'));
        }
        circle(xcoord(i), 4*H/5, particlesize);
    }
}

function updateParticles() {
    shuffleArray(indices);

    for (let i = 0; i < 2*numparticles; i++) {
        if(Math.random() < rate && indices[i] < 2*numparticles-1 && !particles[indices[i]+1] && particles[indices[i]]) {
            particles[indices[i]] = false;
            particles[indices[i]+1] = true;
        }
    }
}

function draw() {
    background(255);

    updateParticles();
    drawParticles();
    drawPath();
}