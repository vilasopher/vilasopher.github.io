const blocksize = 2;
const numcolumns = window.innerWidth / blocksize;
const numrows = window.innerHeight / blocksize;
const rate = 32;

let keepgoing = true
let h = 0

let columnheights = []
let columnclocks = []

let columns = []

function setup() {
  createCanvas(window.innerWidth, window.innerHeight);
  
  for (let c = 0; c < numcolumns+2; c++) {
    columnheights[c] = 0
    columnclocks[c] = exponential_tick()
  }
  
  for (let c = 0; c < numcolumns; c++) {
    columns[c] = c+1
  }
  
  for (let c = 0; c < numcolumns+2; c++) {
    columnclocks[c] = exponential_tick()
  }
  
  strokeWeight(0.1)
}

function draw() {  
  if (keepgoing) {
    
    shuffle_array(columns);
    
    for (let i = 0; i < numcolumns; i++) {
      let c = columns[i];
      
      columnclocks[c] -= 1/128;

      if (columnclocks[c] <= 0) {
        columnclocks[c] = exponential_tick();

        let blockheight = max(columnheights[c] + 1, columnheights[c-1], columnheights[c+1]);
        
        h = (h + 0.005) % 360
        let col = color('hsl('+String(Math.floor(h))+', 100%, 50%)');
        fill(col);
        square((c-1) * blocksize, (numrows - blockheight) * blocksize, blocksize);

        columnheights[c] = blockheight;

        if (columnheights[c] >= numrows + 50) {
          keepgoing = false;
        }
      }
    }
  }
}

function exponential_tick() {
  return - Math.log(1.0 - Math.random()) / rate;
}

function shuffle_array(arr) {
  arr.sort(() => Math.random() - 0.5);
}
