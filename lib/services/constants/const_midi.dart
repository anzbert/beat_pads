enum Chord {
  major('major', [0, 4, 7]),
  minor('minor', [0, 3, 7]),
  xSus2('sus2', [0, 2, 7]),
  xSus4('sus4', [0, 5, 7]),
  x6('6', [0, 4, 7, 9]),
  x7('7', [0, 4, 7, 10]),
  x7Dim5('7 dim5', [0, 4, 6, 10]),
  x7Add5('7 add5', [0, 4, 8, 10]),
  x7Sus4('7 sus4', [0, 5, 7, 10]),
  xm6('m6', [0, 3, 7, 9]),
  xm7('m7', [0, 3, 7, 10]),
  xm7Dim5('m7 dim5', [0, 3, 6, 10]),
  xDim6('dim6', [0, 3, 6, 9]),
  xMaj7('Maj7', [0, 4, 7, 11]),
  xM7add5('Maj7 add5', [0, 4, 8, 11]),
  xmM7('m Maj7', [0, 3, 7, 11]),
  xAdd9('add9', [0, 4, 7, 14]),
  xmAdd9('m add9', [0, 3, 7, 14]),
  x2('2', [0, 4, 7, 14]),
  xAdd11('add11', [0, 4, 7, 17]),
  xm69('m6 9', [0, 3, 7, 9, 14]),
  x69('6 9', [0, 4, 7, 9, 14]),
  x9('9', [0, 4, 7, 10, 14]),
  xm9('m9', [0, 3, 7, 10, 14]),
  xMaj9('Maj7 9', [0, 4, 7, 11, 14]),
  x9Sus4('9 sus4', [0, 5, 7, 10, 14]),
  x7Dim9('7 dim9', [0, 4, 7, 10, 13]),
  x7Add11('7 add11', [0, 4, 7, 10, 18]);

  const Chord(this.label, this.intervals);
  final List<int> intervals;
  final String label;

  /// Returns chord notes of a given base note (0-127)
  List<int> getChord(int baseNote, [Inversion inv = Inversion.first]) {
    final List<int> chord = intervals.map((n) => n + baseNote).toList();
    switch (inv) {
      case Inversion.first:
        break;
      case Inversion.second:
        chord[0] = chord[0] + 12;
      case Inversion.third:
        chord[0] = chord[0] + 12;
        chord[1] = chord[1] + 12;
    }
    return chord.where((n) => n < 128).toList();
  }

  /// Returns chord notes of a given root note in a given octave (-2 to 7)
  List<int> getChordOfOctave(int rootNote, int octave) {
    return intervals
        .map((n) => n + (rootNote % 12) + (octave + 2).clamp(0, 9) * 12)
        .where((n) => n < 128)
        .toList();
  }
}

enum Inversion {
  first,
  second,
  third;
}

// enum Note {
//   c('C', 0, Sign.none),
//   cSharp('C#', 1, Sign.sharp),
//   dFlat('Db', 1, Sign.flat),
//   d('D', 2, Sign.none),
//   dSharp('D#', 3, Sign.sharp),
//   eFlat('Eb', 3, Sign.flat),
//   e('E', 4, Sign.none),
//   f('F', 5, Sign.none),
//   fSharp('F#', 6, Sign.sharp),
//   gFlat('Gb', 6, Sign.flat),
//   g('G', 7, Sign.none),
//   gSharp('G#', 8, Sign.sharp),
//   aFlat('Ab', 8, Sign.flat),
//   a('A', 9, Sign.none),
//   aSharp('A#', 10, Sign.sharp),
//   bFlat('Ab', 10, Sign.flat),
//   b('B', 11, Sign.none);

//   const Note(this.label, this.semitone, this.sign);
//   final int semitone;
//   final String label;
//   final Sign sign;

//   @override
//   String toString() {
//     return label;
//   }

//   int getInterval(Note other) {
//     return (semitone - other.semitone).abs();
//   }

//   static Note fromSemitone(int note, [Sign sign = Sign.sharp]) {
//     for (final val in Note.values) {
//       if (val.semitone == (note % 12)) {
//         if (val.sign == sign || val.sign == Sign.none) return val;
//       }
//     }
//     throw ArgumentError('Note undefined');
//   }
// }

enum Sign { sharp, flat, none }

const Map<int, String> midiNotes = {
  0: 'C',
  2: 'D',
  4: 'E',
  5: 'F',
  7: 'G',
  9: 'A',
  11: 'B',
};

const Map<int, String> midiNotesSharps = {
  ...midiNotes,
  1: 'C#',
  3: 'D#',
  6: 'F#',
  8: 'G#',
  10: 'A#',
};

// const Map<int, String> midiNotesFlats = {
//   ...midiNotes,
//   1: 'Db',
//   3: 'Eb',
//   6: 'Gb',
//   8: 'Ab',
//   10: 'Bb',
// };

const Map<int, String> midiSolfegeNotes = {
  0: 'Do',
  2: 'Re',
  4: 'Mi',
  5: 'Fa',
  7: 'Sol',
  9: 'La',
  11: 'Ti',
};

const Map<int, String> midiSolfegeNotesSharps = {
  ...midiSolfegeNotes,
  1: 'Di',
  3: 'Ri',
  6: 'Fi',
  8: 'Si',
  10: 'Li',
};

// const Map<int, String> midiSolfegeNotesFlats = {
//   ...midiSolfegeNotes,
//   1: 'Ra',
//   3: 'Me',
//   6: 'Se',
//   8: 'Le',
//   10: 'Te',
// };

//(thx to gleitz [https://gist.github.com/gleitz/6845751])
/// Selection of musical scales
enum Scale {
  chromatic([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]),
  major([0, 2, 4, 5, 7, 9, 11]),
  minor([0, 2, 3, 5, 7, 8, 10]),
  harmonicMinor([0, 2, 3, 5, 7, 8, 11], 'harmonic minor'),
  melodicMinor([0, 2, 3, 5, 7, 9, 11], 'melodic minor'),
  pentatonicMinor([0, 3, 5, 7, 10], 'pentatonic minor'),
  pentatonicMajor([0, 2, 4, 7, 9], 'pentatonic major'),
  ionian([0, 2, 4, 5, 7, 9, 11]),
  dorian([0, 2, 3, 5, 7, 9, 10]),
  phrygian([0, 1, 3, 5, 7, 8, 10]),
  lydian([0, 2, 4, 6, 7, 9, 11]),
  mixolydian([0, 2, 4, 5, 7, 9, 10]),
  aeolian([0, 2, 3, 5, 7, 8, 10]),
  locrian([0, 1, 3, 5, 6, 8, 10]),
  blues([0, 3, 5, 6, 7, 10]),
  flamenco([0, 1, 3, 4, 5, 7, 8, 10]),
  spanish8Tone([0, 1, 3, 4, 5, 6, 8, 10], 'spanish 8-tone'),
  symmetrical([0, 1, 3, 4, 6, 7, 9, 10]),
  invertedDiminished([0, 1, 3, 4, 6, 7, 9, 10], 'inverted diminished'),
  diminished([0, 2, 3, 5, 6, 8, 9, 11]),
  wholeTone([0, 2, 4, 6, 8, 10]),
  augmented([0, 3, 4, 7, 8, 11]),
  threeSemitone([0, 3, 6, 9], '3 semitone'),
  fourSemitone([0, 4, 8], '4 semitone'),
  indian([0, 1, 3, 4, 7, 8, 10]),
  javanese([0, 1, 3, 5, 7, 9, 10]),
  neapolitanMinor([0, 1, 3, 5, 7, 8, 11], 'neapolitan minor'),
  neapolitanMajor([0, 1, 3, 5, 7, 9, 11], 'neapolitan minor'),
  todi([0, 1, 3, 6, 7, 8, 11]),
  persian([0, 1, 4, 5, 6, 8, 11]),
  oriental([0, 1, 4, 5, 6, 9, 10]),
  spanish([0, 1, 4, 5, 7, 8, 10]),
  jewish([0, 1, 4, 5, 7, 8, 10]),
  gypsy([0, 1, 4, 5, 7, 8, 11]),
  doubleHarmonic([0, 1, 4, 5, 7, 8, 11], 'double harmonic'),
  byzantine([0, 1, 4, 5, 7, 8, 11]),
  chahargah([0, 1, 4, 5, 7, 8, 11]),
  marva([0, 1, 4, 6, 7, 9, 11]),
  enigmatic([0, 1, 4, 6, 8, 10, 11]),
  hungarianMinor([0, 2, 3, 6, 7, 8, 11], 'hungarian minor'),
  hungarianMajor([0, 3, 4, 6, 7, 9, 10], 'hungarian major'),
  algerian1([0, 2, 3, 6, 7, 8, 11]),
  algerian2([0, 2, 3, 5, 7, 8, 10]),
  mohammedan([0, 2, 3, 5, 7, 8, 11]),
  romanian([0, 2, 3, 6, 7, 9, 10]),
  arabian([0, 1, 4, 5, 7, 8, 11]),
  hindu([0, 2, 4, 5, 7, 8, 10]),
  ethiopian([0, 2, 4, 5, 7, 8, 11]),
  phrygianMajor([0, 1, 4, 5, 7, 8, 10], 'phrygian major'),
  harmonicMajor([0, 2, 4, 5, 8, 9, 11], 'harmonic major'),
  mixolydianAugmented([0, 2, 4, 5, 8, 9, 10], 'mixolydian augmented'),
  lydianMinor([0, 2, 4, 6, 7, 8, 10], 'lydian minor'),
  lydianDominant([0, 2, 4, 6, 7, 9, 10], 'lydian dominant'),
  lydianAugmented([0, 2, 4, 6, 8, 9, 10], 'lydian augmented'),
  locrianMajor([0, 2, 4, 5, 6, 8, 10], 'locrian major'),
  locrianNatural([0, 2, 3, 5, 6, 8, 10], 'locrian natural'),
  locrianSuper([0, 1, 3, 4, 6, 8, 10], 'locrian super'),
  locrianUltra([0, 1, 3, 4, 6, 8, 9], 'locrian ultra'),
  overtone([0, 2, 4, 6, 7, 9, 10]),
  leadingWholeTone([0, 2, 4, 6, 8, 10, 11], 'leading whole tone'),
  balinese([0, 1, 3, 7, 8]),
  pelog([0, 1, 3, 7, 10]),
  japanese([0, 1, 5, 7, 8]),
  iwato([0, 1, 5, 6, 10]),
  kumoi([0, 1, 5, 7, 8]),
  hirajoshi([0, 2, 3, 7, 8]),
  pa([0, 2, 3, 7, 8]),
  pb([0, 1, 3, 6, 8]),
  pd([0, 2, 3, 7, 9]),
  pe([0, 1, 3, 7, 8]),
  pfcg([0, 2, 4, 7, 9]),
  chinese1([0, 2, 4, 7, 9]),
  chinese2([0, 4, 6, 7, 11]),
  mongolian([0, 2, 4, 7, 9]),
  egyptian([0, 2, 3, 6, 7, 8, 11]),
  altered([0, 1, 3, 4, 6, 8, 10]),
  bebopDominant([0, 2, 4, 5, 7, 9, 10, 11], 'bebop dominant'),
  bebopDominantFlatNine([0, 1, 4, 5, 7, 9, 10, 11], 'bebop dominant flat9'),
  bebopMajor([0, 2, 4, 5, 7, 8, 9, 11], 'bebop major'),
  bebopMinor([0, 2, 3, 5, 7, 8, 9, 10], 'bebop minor'),
  bebopTonicMinor([0, 2, 3, 5, 7, 8, 9, 11], 'bebop tonic minor');

  const Scale(this.intervals, [this.label]);
  final List<int> intervals;
  final String? label;

  @override
  String toString() => label == null ? name : label!;
}

class Perc {
  Perc(this.title, this.type);
  final String title;
  final PercType type;
}

enum PercType {
  kick,
  tom,
  handDrum,
  perc,
  snare,
  hat,
  cymbal,
  sfx,
  ;

  static Perc? getType(int note) {
    return gm2PercStandard[note];
  }
}

/// General Midi Standard Percussion layout
Map<int, Perc> gm2PercStandard = {
  27: Perc('Hi-Q', PercType.sfx),
  28: Perc('Slap', PercType.snare),
  29: Perc('Scratch Push', PercType.sfx),
  30: Perc('Scratch Pull', PercType.sfx),
  31: Perc('Sticks', PercType.perc),
  32: Perc('Square Click', PercType.sfx),
  33: Perc('Metro Click', PercType.sfx),
  34: Perc('Metro Bell', PercType.sfx),
  35: Perc('Ac. Kick', PercType.kick),
  36: Perc('Kick 1', PercType.kick),
  37: Perc('Side Stick', PercType.snare),
  38: Perc('Ac. Snare', PercType.snare),
  39: Perc('Hand Clap', PercType.snare),
  40: Perc('Elec. Snare', PercType.snare),
  41: Perc('Lo Floor Tom', PercType.tom),
  42: Perc('Closed HiHat', PercType.hat),
  43: Perc('Hi Floor Tom', PercType.tom),
  44: Perc('Pedal HiHat', PercType.hat),
  45: Perc('Lo Tom', PercType.tom),
  46: Perc('Open HiHat', PercType.hat),
  47: Perc('Lo-Mid Tom', PercType.tom),
  48: Perc('Hi-Mid Tom', PercType.tom),
  49: Perc('Crash Cymb1', PercType.cymbal),
  50: Perc('Hi Tom', PercType.tom),
  51: Perc('Ride Cymb1', PercType.cymbal),
  52: Perc('Chinese Cymb', PercType.cymbal),
  53: Perc('Ride Bell', PercType.cymbal),
  54: Perc('Tambourine', PercType.perc),
  55: Perc('Splash Cymb', PercType.cymbal),
  56: Perc('Cowbell', PercType.sfx),
  57: Perc('Crash Cymb2', PercType.cymbal),
  58: Perc('Vibraslap', PercType.perc),
  59: Perc('Ride Cymb2', PercType.cymbal),
  60: Perc('Hi Bongo', PercType.handDrum),
  61: Perc('Lo Bongo', PercType.handDrum),
  62: Perc('Mut Hi Conga', PercType.handDrum),
  63: Perc('Op Hi Conga', PercType.handDrum),
  64: Perc('Lo Conga', PercType.handDrum),
  65: Perc('Hi Timbale', PercType.handDrum),
  66: Perc('Lo Timbale', PercType.handDrum),
  67: Perc('Hi Agogo', PercType.sfx),
  68: Perc('Lo Agogo', PercType.sfx),
  69: Perc('Cabasa', PercType.perc),
  70: Perc('Maracas', PercType.perc),
  71: Perc('Short Whistle', PercType.sfx),
  72: Perc('Long Whistle', PercType.sfx),
  73: Perc('Short Guiro', PercType.perc),
  74: Perc('Long Guiro', PercType.perc),
  75: Perc('Claves', PercType.perc),
  76: Perc('Hi Woodblock', PercType.perc),
  77: Perc('Lo Woodblock', PercType.perc),
  78: Perc('Mut Cuica', PercType.sfx),
  79: Perc('Op Cuica', PercType.sfx),
  80: Perc('Mut Triangle', PercType.sfx),
  81: Perc('Op Triangle', PercType.sfx),
  82: Perc('Shaker', PercType.perc),
  83: Perc('Jingle Bell', PercType.perc),
  84: Perc('Bell Tree', PercType.perc),
  85: Perc('Castanets', PercType.perc),
  86: Perc('Mut Surdo', PercType.handDrum),
  87: Perc('Op Surdo', PercType.handDrum),
};

enum CC {
  modWheel(1),
  breath(2),
  footPedal(4),
  gain(7),
  pan(10),
  expression(11),
  sustainPedal(64),
  portamento(65),
  sostenuto(66),
  softPedal(67),
  legato(68),
  slide(74),
  allSoundsOff(120),
  allNotesOff(123),
  ;

  const CC(this.value);
  final int value;

  /// A list of all undefined and general purpose CCs (76 in total)
  static List<int> get undefined {
    return [
      3,
      9,
      ...List.generate(64 - 14, (index) => index + 14),
      ...List.generate(91 - 85, (index) => index + 85),
      ...List.generate(120 - 102, (index) => index + 102),
    ];
  }
}

/*
MIDI CC List – Complete List
	0 Bank Select (MSB)
	1 Modulation Wheel
	2 Breath controller
	3 = Undefined
	4 Foot Pedal (MSB)
	5 Portamento Time (MSB)
	6 Data Entry (MSB)
	7 Volume / Gain (MSB)
	8 Balance (MSB
	9 = Undefined
	10 Pan position (MSB)
	11 Expression (MSB)
	12 Effect Control 1 (MSB)
	13 Effect Control 2 (MSB)
	14 = Undefined
	15 = Undefined
	16-19 = General Purpose
	20-31 = Undefined
	32-63 = Controller 0-31
	64 Hold Pedal (on/off)
	65 Portamento (on/off)
	66 Sostenuto Pedal (on/off)
	67 Soft Pedal (on/off)
	68 Legato Pedal (on/off)
	69 Hold 2 Pedal (on/off)
	70 Sound Variation
	71 Resonance (Timbre)
	72 Sound Release Time
	73 Sound Attack Time
	74 Frequency Cutoff (Brightness) / Timbre
	75 Sound Control 6
	76 Sound Control 7
	77 Sound Control 8
	78 Sound Control 9
	79 Sound Control 10
	80 Decay or General Purpose Button 1 (on/off) Roland Tone level 1
	81 Hi Pass Filter Frequency or General Purpose Button 2 (on/off) Roland Tone level 2
	82 General Purpose Button 3 (on/off) Roland Tone level 3
	83 General Purpose Button 4 (on/off) Roland Tone level 4
	84 Portamento Amount
	85-90 = Undefined
	91 Reverb Level
	92 Tremolo Level
	93 Chorus Level
	94 Detune Level
	95 Phaser Level
	96 Data Button increment
	97 Data Button decrement
	98 Non-registered Parameter (LSB)
	99 Non-registered Parameter (MSB)
	100 Registered Parameter (LSB)
	101 Registered Parameter (MSB)
	102-119 = Undefined
	120 All Sound Off
	121 All Controllers Off
	122 Local Keyboard (on/off)
	123 All Notes Off
	124 Omni Mode Off
	125 Omni Mode On
	126 Mono Operation
	127 Poly Mode
*/
