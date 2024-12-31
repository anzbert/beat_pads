import 'package:beat_pads/services/services.dart';

enum PadLabels {
  note('Note Names'),
  value('Midi Value'),
  none('None');

  const PadLabels(this.title);
  final String title;

  @override
  String toString() => title;

  static Label getLabel({
    required PadLabels padLabels,
    required int note,
    required bool gmLabel,
    required Layout layout,
  }) {
    final Label label = Label();

    if (layout == Layout.progrChange) {
      return Label(title: '${note + 1}', subtitle: 'Program');
    }

    if (gmLabel) {
      label.subtitle = MidiUtils.getNoteName(note, gmPercussionLabels: true);
    }

    if (padLabels == PadLabels.none) return label;

    if (padLabels == PadLabels.note) {
      label.title = MidiUtils.getNoteName(note);
    }
    if (padLabels == PadLabels.value) {
      label.title = note.toString();
    }

    return label;
  }
}

class Label {
  Label({this.title, this.subtitle});
  String? title;
  String? subtitle;
}
