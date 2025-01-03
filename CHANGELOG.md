# CHANGELOG

## 1.0.8

- Fix Icon color
- Fix unpredicatable rotation lock behaviour

## 1.0.7

- Remove different color screen flash on app startup in dark mode

## 1.0.4

- System dark mode setting now determines the Splash Screen background
- Added setting to disable Doggo splash screen
- Menu layout bug fixes

## 1.0.3

- Adjust label font sizing on pads to improve legibility on all screen sizes

## 1.0.1

- Fix screen rotation lock bug
- I guess its time for a new major version ;)

## 0.9.40

- Performance Improvements

## 0.9.38

- Add fixed Color Wheel mode
- Add colorouring by GM drum type
- Add GM Percussion Drum Label switch
- Update Slider styling and increase slider size
- Add visual dividers to Pitch Bend slider
- Fix responsiveness of Sustain button with custom GestureDetector
- Add Guitar Tuning Layout. Works like Standard 6-String Guitar tuning (or 4-String Bass)
- Update buildchain to latest Gradle for some platforms
- Improve refresh performance when changing layout size
- Fix missing colors in menu

## 0.9.35

Nov 2, 2024

- Played pads now remain visually activated while Sustain is pressed
- Improved responsiveness of Sustain button
- Bugfix in Base Note Dropdown Menu not making all notes available in chromatic modes
- Bugfix in pad colorization when active with Sustain

## 0.9.34

Nov 1, 2024

- Played pads now remain visually activated while Sustain is pressed

## 0.9.33

Oct 27, 2024

- Bugfix: Central -Tune zone settings did not work in MPE Push Mode

## 0.9.32

Jul 20, 2024

- Updated dependencies to latest versions, which includes fixes to Wakelock and Midi Implementation

## 0.9.31

May 14, 2024

- Updated toolchain (Flutter 3.22 / XCode / iOS 17.5)
- Performance Improvement: Enable Impeller Rendering Engine on iOS

## 0.9.30

May 5, 2024

- Improved: UI readability changes
- Improved: Less layout clutter

## 0.9.29

May 1, 2024

- Improved: Program Change mode settings UI
- Improved: Base note selection UI

## 0.9.28

Apr 30, 2024

- Added: Basic program change sending layout
- Fixed: The full octave range wasn't available anymore

## 0.9.26

Apr 28, 2024

- Added Channel Aftertouch
- Added more explainer text

## 0.9.25

Apr 16, 2024

- minor fixes

## 0.9.24

Apr 15, 2024

- MPE Push Style: Relative mode
- MPE Push Style: New Visualization
- MPE Push Style: Bugfixes

## 0.9.23

Apr 14, 2024

- MPE Push Style: Set type of modulation for-Axis
- MPE Push Style: Visualization
- MPE Push Style: -Tune Deadzone Setting

## 0.9.22

Apr 13, 2024

- Pu-Style MPE: Added option to restrict modulation to current row to avoid jumps in pitch when accidentally sliding up or down to far.

## 0.9.21

Apr 8, 2024

- EXPERIMENTAL FEATURE: Added Push style MPE mode

## 0.9.19

Mar 9, 2024

- Custom-Y interval modes for chromatic and -key layouts
- New option to allow fader manipulation by touching the tracks

## 0.9.16

Mar 6, 2024

- Removed Harmonic Table and Tritone layout in favor of a fully customizable interval layout option, which covers both and is a lot more versatile.

## 0.9.15

Mar 4, 2024

- Harmonic Table layout

## 0.9.14

Oct 17, 2023

- dependency update with iOS bugfixes

## 0.9.13

Oct 13, 2023

- fixed all links opening from System page

## 0.9.12

Oct 6, 2023

- updated dependency with an iOS bug fix

## 0.9.11

Aug 22, 2023

- Sliders only change now when being dragged with the thumb to prevent accidental changes

## 0.9.10

Jul 18, 2023

- reduce minimum grid dimensions to 1 in width and height

## 0.9.9

Jul 14, 2023

- rollback due to note off error
- splash screen name

## 0.9.8

Jul 11, 2023

- rollback to a previous release, due to bugs with missing Note Offs in last release

## 0.9.7

Jul 4, 2023

- Relaunched App with new name
- New Rendering Engine with improved performance on iOS
- Chunky source rewrite with plenty of bug fixes and removal of legacy code
- Added Tritone and Quint Layouts
