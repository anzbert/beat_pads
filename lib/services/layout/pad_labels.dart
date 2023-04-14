import 'package:beat_pads/services/services.dart';

enum PadLabels {
  note('Note Names'),
  value('Midi Value'),
  none('None');

  const PadLabels(this.title);
  final String title;

  @override
  String toString() => title;

  static Label getLabel(PadLabels padLabels, Layout layout, int note) {
    final Label label = Label();

    if (padLabels == PadLabels.none) return label;

    if (padLabels == PadLabels.note) {
      label.title = MidiUtils.getNoteName(note);
    }
    if (padLabels == PadLabels.value) {
      label.title = note.toString();
    }
    if (layout.gmPercussion) {
      label.subtitle = MidiUtils.getNoteName(note, gmPercussionLabels: true);
    }

    return label;
  }
}

class Label {
  Label({this.title, this.subtitle});
  String? title;
  String? subtitle;
}
