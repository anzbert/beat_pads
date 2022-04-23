// import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

// abstract class PadUtils {
//   static int handlePush(
//       int channel, int note, bool sendCC, int velocity, int sustainTime) {
//     NoteOnMessage(channel: channel, note: note, velocity: velocity).send();

//     if (sendCC) {
//       CCMessage(channel: (channel + 1) % 16, controller: note, value: 127)
//           .send();
//     }

//     return DateTime.now().millisecondsSinceEpoch; // return triggertime
//   }

//   static handleRelease(int channel, int note, bool? sendCC, int sustainTime,
//       int triggerTime) async {
//     int timeNow = DateTime.now().millisecondsSinceEpoch;

//     if (timeNow - triggerTime < sustainTime) return;

//     NoteOffMessage(
//       channel: channel,
//       note: note,
//     ).send();

//     if (sendCC == true) {
//       CCMessage(channel: (channel + 1) % 16, controller: note, value: 0).send();
//     }
//   }

//   static Future<bool> checkSustainTime(int sustainTime, int triggerTime) =>
//       Future.delayed(
//         const Duration(milliseconds: 5),
//         () => DateTime.now().millisecondsSinceEpoch - triggerTime > sustainTime,
//       );
// }
