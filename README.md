# Two-Point Interference Pattern Simulator
An interactive physics visualization where expanding wavefronts from two coherent sources form mathematically exact hyperbolic nodal lines in real-time.

**[▶ Try it in your browser](https://taehyunnnnn.github.io/twoPointInterferencePatternSimulator.processing/)**

![demo](assets/demo.gif)

---

## Overview
This simulator renders the classic two-point wave interference pattern by animating expanding circular wavefronts and computing destructive interference lines as true hyperbolas — the locus of points where path difference equals a half-wavelength multiple. Built in Processing to make abstract wave optics tangible and visually satisfying. Wavelength, frequency, and source separation are all adjustable live so you can watch the pattern reshape instantly.

---

## Features
- Animated expanding wavefronts from two coherent point sources
- Real-time hyperbolic nodal (destructive interference) lines with no gaps
- Live parameter tuning: wavelength, frequency, and source distance
- Pause/resume and independent toggles for waves and nodal lines

---

## Getting Started

### Option 1 — Browser (no install)
**[▶ Open the live demo](https://taehyunnnnn.github.io/twoPointInterferencePatternSimulator.processing/)**

### Option 2 — Run locally with Processing
#### Prerequisites
- Processing 4+

#### Run
```bash
# clone the repo
git clone https://github.com/taehyunnnnn/twoPointInterferencePatternSimulator.processing
cd twoPointInterferencePatternSimulator.processing

# open and run
make run
```

`make run` opens the sketch in Processing IDE. Click **▶**, then press **Enter** on the title screen.

---

## Controls
| Input | Action |
|---|---|
| Enter | Start simulation |
| Q / A | Increase / decrease wavelength |
| W / S | Increase / decrease frequency |
| E / D | Increase / decrease source distance |
| R | Toggle nodal lines |
| F | Toggle wave circles |
| Space | Pause / resume |

---

## What I Learned
- Modeling wave propagation and interference mathematically using path difference
- Deriving and rendering hyperbolic nodal lines as exact curves instead of sampled dots
- Using `beginShape()` / `vertex()` / `endShape()` in Processing for smooth continuous curves
- Managing real-time animation timing with accurate pause/resume state tracking

---

## Author
**Taehyun Im**
[GitHub](https://github.com/taehyunnnnn) · [Portfolio](https://taehyun.pages.dev) · [LinkedIn](https://linkedin.com/in/taehyunim)

---

## Acknowledgments
- Two-point interference theory from standard wave optics curriculum
- [Processing Foundation](https://processing.org) for the creative coding environment
- [p5.js](https://p5js.org) for the browser port
