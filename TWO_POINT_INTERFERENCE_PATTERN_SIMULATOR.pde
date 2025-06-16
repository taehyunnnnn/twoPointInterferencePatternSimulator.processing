// TWO POINT INTERFERENCE PATTERN SIMULATOR
// TAEHYUN IM (BOYD)
// 2025.06.12



// ----- TITLE SCREEN VARIABLES -----
// Controls whether the title screen is shown
boolean showTitleScreen = true;

// ASCII art title displayed on the title screen, each line centered manually

String[] asciiTitle = {
  "     +-+-+-+ +-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+     ",
  "      T  W O   P O I N T   I N T E R F E R E N C E   P A T T E R N      ",
  "     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+     ",
  "               B y   T a e h y u n   I m   ( B o y d )               ",
  "              +-+-+-+-+-+-+-+-+-+-+ +-+-+ +-+-+-+-+-+-+              ",
  "                         2 0 2 5 . 0 6 . 1 2                         ",
  "                        +-+-+-+-+-+-+-+-+-+-+                        ",
  "                                                                     ",
  "                     >>>  PRESS ENTER TO START  <<<                      "
};

// ----- SIMULATION VARIABLES -----
// Wavelength of the waves (in pixels)
float wavelength = 25;

// Frequency of the waves (in Hz)
float frequency = 1.5;

// Speed of wave propagation, calculated as wavelength * frequency
float waveSpeed = 50;

// Distance between the two wave sources (in pixels)
float sourceDistance = 200;

// Pause control variables
boolean paused = false;       // Whether simulation is paused
boolean showCircle = true;    // Show expanding wave circles or not
boolean showDot = true;       // Show nodal interference points or not

// Positions of the two wave sources
PVector source1, source2;

// Timing variables to handle animation timing and pause functionality
float startTime;             // Time when simulation started (seconds)
float currentTime = 0;       // Time elapsed in simulation (seconds)
float pausedStartTime = 0;   // Time when pause started (seconds)
float totalPausedTime = 0;   // Accumulated paused duration (seconds)

void setup() {
  size(1000, 600);      // Canvas size
  smooth();             // Enable anti-aliasing for nicer drawing
  frameRate(60);        // Target 60 frames per second
  ellipseMode(CENTER);  // Draw ellipses from center point
  textAlign(CENTER, CENTER);  // Center text horizontally and vertically
  textSize(14);         // Text size for labels and title
  fill(0, 255, 255);    // Cyan color for text and dots
  noStroke();

  // Initialize source positions based on initial distance
  source1 = new PVector(width / 2 - sourceDistance / 2, height / 2);
  source2 = new PVector(width / 2 + sourceDistance / 2, height / 2);
  
  // Record the start time in seconds
  startTime = millis() / 1000.0;
}

void draw() {
  if (showTitleScreen) {
    // Draw the title screen and skip simulation draw
    drawTitleScreen();
    return;
  }

  background(0);  // Black background

  // Update elapsed simulation time only if not paused
  if (!paused) {
    currentTime = millis() / 1000.0 - startTime - totalPausedTime;
  }

  // Wave speed is wavelength * frequency (pixels per second)
  waveSpeed = wavelength * frequency;

  // Update sources in case sourceDistance has changed
  source1.x = width / 2 - sourceDistance / 2;
  source2.x = width / 2 + sourceDistance / 2;

  // Draw the wave circles expanding from each source
  if (showCircle) {
    drawWaveCircles(source1, currentTime);
    drawWaveCircles(source2, currentTime);
  }

  // Draw nodal points of interference if enabled
  if (showDot) {
    drawNodalDots(source1, source2, currentTime);
  }

  // Draw control labels on screen
  drawLabels();

  // Draw the sources as red filled circles
  fill(255, 0, 0);
  stroke(255, 0, 0);
  strokeWeight(4);
  ellipse(source1.x, source1.y, 10, 10);
  ellipse(source2.x, source2.y, 10, 10);
}

// Draw the ASCII title screen
void drawTitleScreen() {
  background(0);
  fill(0, 255, 255);
  for (int i = 0; i < asciiTitle.length; i++) {
    text(asciiTitle[i], width / 2, height / 4 + i * 18 + 50);
  }
}

// Draw expanding wave circles for a given source and current time
void drawWaveCircles(PVector source, float currentTime) {
  noFill();
  strokeWeight(1.2);
  stroke(255, 255, 255, 150); // White circles with transparency

  float maxRadius = currentTime * waveSpeed;

  // Start drawing circles from a radius that makes the animation smooth
  float startRadius = maxRadius % wavelength;

  for (float r = startRadius; r < maxRadius; r += wavelength) {
    ellipse(source.x, source.y, r * 2, r * 2);
  }
}

// Draw the nodal points where destructive interference occurs
void drawNodalDots(PVector s1, PVector s2, float currentTime) {
  float maxRadius = currentTime * waveSpeed;
  float step = wavelength / 20.0;  // Dot placement resolution

  fill(0, 255, 255); // Cyan dots
  noStroke();

  // Loop over different path difference multiples where nodal lines occur
  for (int m = 0; (m + 0.5) * wavelength < maxRadius; m++) {
    float pathDiff = (m + 0.5f) * wavelength;

    // For each circle radius of source1, check for intersection with corresponding circle on source2
    for (float r1 = 0; r1 <= maxRadius; r1 += step) {
      float r2 = r1 - pathDiff;
      if (r2 < 0 || r2 > maxRadius) continue;

      ArrayList<PVector> intersections = circleCircleIntersection(s1, r1, s2, r2);
      for (PVector p : intersections) {
        ellipse(p.x, p.y, 4, 4);  // Draw dot at intersection
        float mirrorX = width - p.x;
        ellipse(mirrorX, p.y, 4, 4); // Symmetric dot on other side (for visual effect)
      }
    }
  }
}

// Calculate intersection points of two circles given centers and radii
ArrayList<PVector> circleCircleIntersection(PVector c1, float r1, PVector c2, float r2) {
  ArrayList<PVector> points = new ArrayList<PVector>();

  float dx = c2.x - c1.x;
  float dy = c2.y - c1.y;
  float d = dist(c1.x, c1.y, c2.x, c2.y);

  // No intersections if circles are too far apart or one is contained inside the other
  if (d > r1 + r2 || d < abs(r1 - r2) || d == 0) return points;

  float a = (r1 * r1 - r2 * r2 + d * d) / (2 * d);
  float h = sqrt(r1 * r1 - a * a);

  float x2 = c1.x + a * dx / d;
  float y2 = c1.y + a * dy / d;

  float rx = -dy * h / d;
  float ry = dx * h / d;

  points.add(new PVector(x2 + rx, y2 + ry));
  points.add(new PVector(x2 - rx, y2 - ry));
  return points;
}

// Draw control instructions and current parameter values
void drawLabels() {
  fill(0, 0, 0, 150); // Semi-transparent black background for text
  noStroke();
  rect(5, 5, 200, 133);

  fill(0, 255, 255);
  textAlign(LEFT, CENTER);
  textSize(14);
  text("Wavelength (Q/A): " + nf(wavelength, 0, 1), 10, 25);
  text("Frequency (W/S): " + nf(frequency, 0, 1), 10, 45);
  text("Source Distance (E/D): " + nf(sourceDistance, 0, 1), 10, 65);
  text("Pause (SPACEBAR)", 10, 85);
  text("Toggle dots (r)", 10, 105);
  text("Toggle waves (f)", 10, 125);
}

// Handle keyboard input for controls
void keyPressed() {
  if (showTitleScreen && (key == ENTER || key == RETURN)) {
    // Start simulation when enter pressed on title screen
    showTitleScreen = false;
    startTime = millis() / 1000.0;
    totalPausedTime = 0;
    paused = false;
    return;
  }

  // Adjust wavelength with Q/A keys
  if (key == 'q') wavelength += 1;
  if (key == 'a') wavelength -= 1;
  wavelength = constrain(wavelength, 5, 100);

  // Adjust frequency with W/S keys
  if (key == 'w') frequency += 0.1;
  if (key == 's') frequency -= 0.1;
  frequency = constrain(frequency, 0.1, 5);

  // Adjust source distance with E/D keys
  if (key == 'e') sourceDistance += 5;
  if (key == 'd') sourceDistance -= 5;
  sourceDistance = constrain(sourceDistance, 10, 1000);

  // Toggle nodal dots visibility with R
  if (key == 'r') {
    showDot = !showDot;
  }

  // Toggle wave circles visibility with F
  if (key == 'f') {
    showCircle = !showCircle;
  }

  // Pause / Resume simulation with spacebar
  if (key == ' ') {
    paused = !paused;
    if (paused) {
      // Record when pause started to adjust total paused duration
      pausedStartTime = millis() / 1000.0;
    } else {
      // Update total paused time when resuming
      float pausedDuration = millis() / 1000.0 - pausedStartTime;
      totalPausedTime += pausedDuration;
    }
  }
}
