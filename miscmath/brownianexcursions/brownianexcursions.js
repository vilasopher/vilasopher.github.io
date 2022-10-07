let zoom = 0.5;
let vertscale = 10;
let lineheight;

let s = 0;
let prev;
let next;

function setup() {
  createCanvas(window.innerWidth, window.innerHeight);
  lineheight = (2/3) * height;
  
  strokeWeight(0.5);
  stroke('blue');
  line(0, lineheight, width, lineheight);
  strokeWeight(1);
  stroke('black');
  
  prev = lineheight;
  next = lineheight;
  
  s += 1;
}

function draw() {
  if (zoom * s < width + 10) {
    for (let i = 0; i < 25; i++) {
      prev = next;
      next = prev + vertscale * randn_bm((s * zoom / (1.5 * width))**2 / 2, zoom);
       
      if (next > lineheight) {
        mid = (next - lineheight)/(next-prev);
        next = lineheight;
        line(zoom * (s-1), prev, zoom * (s-mid), lineheight);
        line(zoom * (s-mid), lineheight, zoom * s, next);
      } else {
        line(zoom * (s-1), prev, zoom * s, next);
      }
      
      s += 1;
    }
  }
}

function randn_bm(mu, sigma) {
    let u = 1 - Math.random(); //Converting [0,1) to (0,1)
    let v = Math.random();
    return mu + sigma * Math.sqrt( -2.0 * Math.log( u ) ) * Math.cos( 2.0 * Math.PI * v );
}
