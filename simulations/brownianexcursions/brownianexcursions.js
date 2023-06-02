let zoom = 0.5;
let vertscale = 20;
let numexcursions = 10;
let lineheight = 2/3;
let offset = 8;

let s = 0;
let prev;
let next;

let excursions = []
let currstart = 0;
let currend = -1;

let written = false;

function setup() {
  createCanvas(window.innerWidth, window.innerHeight);
  lineheight = lineheight * height;
  
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
      advance_brownian_motion();
  } else if (!written) {
      write_results();
      written = true;
  }
}

function advance_brownian_motion() {
  for (let i = 0; i < 25; i++) {
    prev = next;
    next = prev + vertscale * randn_bm(s * zoom / (width*2), zoom);

    if (next > lineheight) {
      mid = (next - lineheight)/(next-prev);
      next = lineheight;
      line(zoom * (s-1), prev, zoom * (s-mid), lineheight);
      line(zoom * (s-mid), lineheight, zoom * s, next);
  
      if (currend < currstart) {
        currend = s-mid;
        excursions.push({start: currstart, end: currend, length: currend - currstart});
      }
    } else {
      line(zoom * (s-1), prev, zoom * s, next);
      
      if (currstart <= currend) {
        currstart = s;
      }
    }
  
    s += 1;
  }
}

function write_results() {
  excursions.sort((a,b) => { return b.length - a.length });

  for (let i = 0; i < numexcursions; i++) {
    strokeWeight(4)
    stroke('red')
    line(
      zoom * excursions[i].start,
      lineheight + (numexcursions - i) * offset,
      zoom * excursions[i].end,
      lineheight + (numexcursions - i) * offset
    )

    strokeWeight(0)
    text(
      (excursions[i].length * zoom / (width * 2)).toFixed(3),
      zoom * (excursions[i].start + excursions[i].end) / 2 - 17,
      lineheight + (numexcursions - i) * offset + 12
    )
  } 
}

function randn_bm(mu, sigma) {
    let u = 1 - Math.random(); //Converting [0,1) to (0,1)
    let v = Math.random();
    return mu + sigma * Math.sqrt( -2.0 * Math.log( u ) ) * Math.cos( 2.0 * Math.PI * v );
}
