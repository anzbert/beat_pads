// ignore_for_file: lines_longer_than_80_chars

import 'dart:io' show Platform;
import 'package:beat_pads/shared_components/_shared.dart';
import 'package:flutter/material.dart';

List<Widget> helpText = [
  if (Platform.isAndroid)
    const StringInfoBox(
      header: 'USB',
      body: [
        'Connect USB cable to Host Device',
        "Slide down the Notification Menu and set the USB connection mode to 'Midi'",
        'If there is no Midi option available, your Android phone may only show this setting in the Developer Menu. Please refer to readily available instructions online on how to access this Menu on your Device',
        'Once Midi mode is activated, refresh this Device List',
        'Tap USB Device to Connect',
        '',
        'Note: The Developer menu allows you to set the default USB connection mode to Midi',
      ],
    ),
  if (Platform.isIOS)
    const StringInfoBox(
      header: 'USB',
      body: [
        'Connect USB cable to Host Device',
        "Open 'Audio MIDI Setup' on Mac and click 'Enable' under iPad/iPhone in the 'Audio Devices' Window",
        'Refresh this Device List',
        "Tap 'IDAM MIDI Host' to Connect",
        '',
        "Note: USB without third-party adapters works only with MacOS devices, due to Apple's MIDI implementation!",
      ],
    ),
  StringInfoBox(
    header: 'Virtual',
    body: [
      if (Platform.isIOS)
        "Some third-Party apps, like 'AudioKit Synth One', make a Virtual Midi Device available on your Phone or Tablet, which you can connect to in Beat Pads through CoreMidi",
      if (Platform.isAndroid)
        "Some third-Party apps, like 'FluidSynth', make a Virtual Midi Device available on your Phone or Tablet, which you can connect to in Beat Pads",
      'When such an App has been installed it will appear in this Device List',
      'After connection, Beat Pads can send Midi Data to the App, for example, to play a Synthesizer on your Device with Beat Pads',
      '',
      'Note: If the receiving App has a Setting to allow it to run in the background, make sure to enable it'
    ],
  ),
  if (Platform.isIOS)
    const StringInfoBox(
      header: 'WiFi',
      body: [
        'Connect to same WiFi as Host Device',
        "Connect to 'Network Session 1' in this Device List",
        "Open 'Audio MIDI Setup' on Mac and open the 'MIDI Studio' window",
        "Create a Session in the 'MIDI Network Setup' window and connect to your iPad/iPhone",
        '',
        "Note: Wireless Protocols add Latency. Connection to Windows Hosts via WiFi requires third-party Software (like 'rtpMIDI')"
      ],
    ),
];
