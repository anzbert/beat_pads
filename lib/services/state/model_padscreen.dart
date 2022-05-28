import 'package:flutter/material.dart';
import '../services.dart';

class PadScreenVariables extends ChangeNotifier {
  PadScreenVariables(this._settings, {this.preview = false});

  Settings _settings;
  bool preview;

  PadScreenVariables update(Settings settings) {
    _settings = settings;
    return this;
  }
}
