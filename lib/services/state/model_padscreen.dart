import 'package:flutter/material.dart';
import '../services.dart';

class PadScreenVariables extends ChangeNotifier {
  /// this could be a temporary logic and variable object for the pads screen
  PadScreenVariables(this.settings, {this.preview = false});

  Settings settings;
  bool preview;

  PadScreenVariables update(Settings settings) {
    settings = settings;
    return this;
  }
}
