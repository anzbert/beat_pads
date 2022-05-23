import 'package:beat_pads/services/services.dart';

enum PadLabels {
  note("Note Names"),
  value("Midi Value"),
  none("None");

  final String title;
  const PadLabels(this.title);

  static PadLabels? fromName(String key) {
    for (PadLabels mode in PadLabels.values) {
      if (mode.name == key) return mode;
    }
    return null;
  }

  static Label getLabel(Settings settings, int note) {
    Label label = Label();

    if (settings.padLabels == PadLabels.none) return label;

    if (settings.padLabels == PadLabels.note) {
      label.title = MidiUtils.getNoteName(note);
    }
    if (settings.padLabels == PadLabels.value) {
      label.title = note.toString();
    }
    if (settings.layout.gmPercussion) {
      label.subtitle = MidiUtils.getNoteName(note, gmPercussionLabels: true);
    }

    return label;
  }
}

class Label {
  String? title;
  String? subtitle;
  Label({this.title, this.subtitle});
}
