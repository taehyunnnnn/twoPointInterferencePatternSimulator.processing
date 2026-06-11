let showTitleScreen = true;

const asciiTitle = [
  "     +-+-+-+ +-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+     ",
  "      T  W O   P O I N T   I N T E R F E R E N C E   P A T T E R N      ",
  "     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+     ",
  "               B y   T a e h y u n   I m   ( B o y d )               ",
  "              +-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+              ",
  "                         2 0 2 5 . 0 6 . 1 2                         ",
  "                        +-+-+-+-+-+-+-+-+-+-+                        ",
  "                                                                     ",
  "                     >>>  PRESS ENTER TO START  <<<                      "
];

let wavelength = 25;
let frequency = 1.5;
let waveSpeed = 50;
let sourceDistance = 200;

let paused = false;
let showCircle = true;
let showDot = true;

let source1, source2;
let startTime, currentTime = 0, pausedStartTime = 0, totalPausedTime = 0;

function setup() {
  createCanvas(1000, 600);
  frameRate(60);
  ellipseMode(CENTER);
  textAlign(CENTER, CENTER);
  textSize(14);
  source1 = createVector(width / 2 - sourceDistance / 2, height / 2);
  source2 = createVector(width / 2 + sourceDistance / 2, height / 2);
  startTime = millis() / 1000.0;
}

function draw() {
  if (showTitleScreen) { drawTitleScreen(); return; }

  background(0);

  if (!paused) {
    currentTime = millis() / 1000.0 - startTime - totalPausedTime;
  }

  waveSpeed = wavelength * frequency;
  source1.x = width / 2 - sourceDistance / 2;
  source2.x = width / 2 + sourceDistance / 2;

  if (showCircle) {
    drawWaveCircles(source1, currentTime);
    drawWaveCircles(source2, currentTime);
  }

  if (showDot) drawNodalLines(source1, source2, currentTime);

  drawLabels();

  fill(255, 0, 0);
  stroke(255, 0, 0);
  strokeWeight(4);
  ellipse(source1.x, source1.y, 10, 10);
  ellipse(source2.x, source2.y, 10, 10);
}

function drawTitleScreen() {
  background(0);
  fill(0, 255, 255);
  noStroke();
  textSize(14);
  textAlign(CENTER, CENTER);
  for (let i = 0; i < asciiTitle.length; i++) {
    text(asciiTitle[i], width / 2, height / 4 + i * 18 + 50);
  }
}

function drawWaveCircles(source, t) {
  noFill();
  strokeWeight(1.2);
  stroke(255, 255, 255, 150);
  let maxRadius = t * waveSpeed;
  let startRadius = maxRadius % wavelength;
  for (let r = startRadius; r < maxRadius; r += wavelength) {
    ellipse(source.x, source.y, r * 2, r * 2);
  }
}

function drawNodalLines(s1, s2, t) {
  let maxRadius = t * waveSpeed;
  let cx = (s1.x + s2.x) / 2.0;
  let cy = (s1.y + s2.y) / 2.0;
  let c = dist(s1.x, s1.y, s2.x, s2.y) / 2.0;

  stroke(0, 255, 255);
  strokeWeight(1.5);
  noFill();

  for (let m = 0; (m + 0.5) * wavelength < maxRadius; m++) {
    let pathDiff = (m + 0.5) * wavelength;
    let a = pathDiff / 2.0;
    if (a >= c) continue;
    let b2 = c * c - a * a;

    for (let branch = -1; branch <= 1; branch += 2) {
      let shapeOpen = false;
      for (let py = 0; py <= height; py++) {
        let yRel = py - cy;
        let xRel = branch * a * sqrt(1.0 + (yRel * yRel) / b2);
        let px = cx + xRel;
        let d1 = dist(px, py, s1.x, s1.y);
        let d2 = dist(px, py, s2.x, s2.y);
        let inBounds = d1 <= maxRadius && d2 <= maxRadius && px >= 0 && px <= width;
        if (inBounds) {
          if (!shapeOpen) { beginShape(); shapeOpen = true; }
          vertex(px, py);
        } else {
          if (shapeOpen) { endShape(); shapeOpen = false; }
        }
      }
      if (shapeOpen) endShape();
    }
  }
}

function drawLabels() {
  fill(0, 0, 0, 150);
  noStroke();
  rect(5, 5, 200, 133);
  fill(0, 255, 255);
  textAlign(LEFT, CENTER);
  textSize(14);
  text("Wavelength (Q/A): " + nf(wavelength, 0, 1), 10, 25);
  text("Frequency (W/S): " + nf(frequency, 0, 1), 10, 45);
  text("Source Distance (E/D): " + nf(sourceDistance, 0, 1), 10, 65);
  text("Pause (SPACEBAR)", 10, 85);
  text("Toggle lines (r)", 10, 105);
  text("Toggle waves (f)", 10, 125);
}

function keyPressed() {
  if (showTitleScreen && keyCode === ENTER) {
    showTitleScreen = false;
    startTime = millis() / 1000.0;
    totalPausedTime = 0;
    paused = false;
    return false;
  }

  if (key === 'q') wavelength += 1;
  if (key === 'a') wavelength -= 1;
  wavelength = constrain(wavelength, 5, 100);

  if (key === 'w') frequency += 0.1;
  if (key === 's') frequency -= 0.1;
  frequency = constrain(frequency, 0.1, 5);

  if (key === 'e') sourceDistance += 5;
  if (key === 'd') sourceDistance -= 5;
  sourceDistance = constrain(sourceDistance, 10, 1000);

  if (key === 'r') showDot = !showDot;
  if (key === 'f') showCircle = !showCircle;

  if (key === ' ') {
    paused = !paused;
    if (paused) {
      pausedStartTime = millis() / 1000.0;
    } else {
      totalPausedTime += millis() / 1000.0 - pausedStartTime;
    }
  }

  return false; // prevent browser default (e.g. spacebar scrolling)
}
