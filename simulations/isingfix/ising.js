let isingShader;

let prevFrame;
let firstFrame = true;

function preload() {
  isingShader = loadShader('ising.vert', 'ising.frag');
}

function setup() {
  width = window.innerWidth;
  height = window.innerHeight;
  createCanvas(width, height, WEBGL);
  pixelDensity(1);
  noSmooth();
  
  prevFrame = createGraphics(width, height);
  prevFrame.pixelDensity(1);
  prevFrame.noSmooth();

  background(0);
  stroke(0,0,255,255);
  strokeWeight(50);
  shader(isingShader);
  isingShader.setUniform("normalRes", [0.5/width, 0.5/height]);
}

function draw() {
  if(mouseIsPressed) {
    line(
      pmouseX-width/2,
      pmouseY-height/2,
      mouseX-width/2,
      mouseY-height/2
    );
  }  
 
  // Set the image of the previous frame into our shader
  isingShader.setUniform('tex', prevFrame);
  isingShader.setUniform('millis', millis());
  isingShader.setUniform('h', 0.);

  if (firstFrame) {
    isingShader.setUniform('beta', 0.0);
    isingShader.setUniform('rate', 1.);
    firstFrame = false;
  } else {
    isingShader.setUniform('beta', 1);
    isingShader.setUniform('rate', 0.1);
  }

  
  // Give the shader a surface to draw on
  rect(-width/2,-height/2,width,height);


  // Copy the rendered image into our prevFrame image
  prevFrame.image(get(), 0, 0);  

}