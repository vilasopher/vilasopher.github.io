let zoom = 0.5;
let vertscale = 10;

let s = 0;
let prev;
let next;

function setup() {
  createCanvas(window.innerWidth, window.innerHeight);
  
  strokeWeight(0.5);
  stroke('blue');
  line(0, height/2, width, height/2);
  strokeWeight(1);
  stroke('black');
  
  prev = height / 2;
  next = height / 2;
  
  s += 1;
}

function draw() {
  for (let i = 0; i < 20; i++) {
    prev = next;
    next = prev + vertscale * randn_bm((s * zoom / (2 * width))**2 / 2, zoom);
    
    if (next > height / 2) {
      mid = (next - height/2)/(next-prev);
      next = height/2 - mid * (next - prev);
      line(zoom * (s-1), prev, zoom * (s-mid), height/2);
      line(zoom * (s-mid), height/2, zoom * s, next);
    } else {
      line(zoom * (s-1), prev, zoom * s, next);
    }
    
    s += 1;
  }
}

function randn_bm(mu, sigma) {
    let u = 1 - Math.random(); //Converting [0,1) to (0,1)
    let v = Math.random();
    return mu + sigma * Math.sqrt( -2.0 * Math.log( u ) ) * Math.cos( 2.0 * Math.PI * v );
}
