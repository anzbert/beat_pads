# Midi Poly Grid

## Installation

### Get it from the App Store and support this project...

- [Apple Store](https://apps.apple.com/us/app/beat-pads/id1633882803)
- [Google Play](https://play.google.com/store/apps/details?id=io.anzio.beat_pads&hl=en_AU&gl=US&pli=1)

### ...or compile it yourself

- Install the [Flutter](https://flutter.dev/) toolchain as per [these instructions](https://docs.flutter.dev/get-started/install)
- Clone or download this repository
- Edit with [VScode](https://code.visualstudio.com/)
- Run an Android or iOS Emulator and try with `flutter run`
- Compile for Android with `flutter build apk` or for iOS with `flutter build ios` and install to a plugged in device with `flutter install`

### ...and maybe:

<a href='https://ko-fi.com/S6S8SP865' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://storage.ko-fi.com/cdn/kofi4.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>

## Information

Midi Poly Grid (formerly known as 'Beat Pads') is a lightweight Midi Controller app for mobile phones and tablets for melodies and finger drumming at home and on the go. Connections can be made virtually to other apps via platform midi channels or via USB to other devices.

This app aims to be an easy-to-use pad input device featuring a variety of layouts, intuitive playability and modern modulation options, such as MPE and Polyphonic Aftertouch. It was designed for people that prefer pads to pianos! The focus of this app is not to be a jack-of-all-trades Midi swiss army knife, but instead to be great at one thing: Intuitive and versatile pad controls.

AUv3 is unfortunately not supported at this time, as it is [currently impossible with Flutter](https://github.com/flutter/flutter/issues/16092).

Wifi works on iOS, but Wifi and Bluetooth support is otherwise limited due to platform restrictions.

## Feature Bullet Points

- A size-adjustable grid of pads for finger drumming and melody input
- Various layouts and colors, inspired by the Ableton Push
- Presets can be saved with different pad setups
- Innovative MPE and polyphonic Aftertouch modulation with graphical feedback
- Push Style MPE pitchbend and slide
- Send Velocity by Y position on pad, randomly or with a fixed value
- Usable as a standard MIDI device with any PC, Mac or other USB host
- Optional controls, such as Pitch Bend, Mod Wheel and Sustain
- Highligh a large number of musical scales
- Receives Midi Notes, making the pads usable like a Launchpad
- Custom grid creation based on the note intervals on the X and Y Axis to create Grids inspired by the Harmonic Table, Wicki Hayden, [MidiMech](https://github.com/flipcoder/midimech) and others
- Supports virtual Midi connection to other apps on your device
- Built-In support for the popular finger drumming courses from XpressPads.com
- And more...

## Feedback and Contributions

Anyone is most welcome to contribute, report an issue or start a discussion in the Github repository. Thanks!

## ToDo List

- Potential issue: iOS devices disconnect from Midi sometimes when screen times out and wakelock is off -> Implement auto-reconnect to last connected devices
- Low Priority: Project still using outdated ChangeNotifier in Riverpod state management -> Refactor

## Licence

Licenced under GPL3. The code in this project is freely usable in any other **open source** project. Enjoy 👍
