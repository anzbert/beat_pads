import 'dart:collection';
import 'package:beat_pads/services/services.dart';

/*
FROM MIDI SPECS ABOUT MPE CHANNELS:
In the simplest workable implementation, a new note will be assigned to the 
Channel with the lowest count of active notes. Then, all else being equal, 
the Channel with the oldest last Note Off would be preferred. This set of 
rules has at least one working real-world implementation.
*/

class MPEChannelGenerator {
  MPEChannelGenerator({required int memberChannels, required bool upperZone})
      : allMemberChannels = List.generate(
          memberChannels,
          (i) => i + (upperZone ? 15 - memberChannels : 1),
          growable: false,
        ),
        channelQueue = Queue.from(
          List<int>.generate(
            memberChannels,
            (i) => i + (upperZone ? 15 - memberChannels : 1),
            growable: false,
          ),
        );

  Queue<int> channelQueue = Queue();
  List<int> allMemberChannels = [];

  void releaseMPEChannel(int channel) {
    if (!channelQueue.contains(channel)) {
      channelQueue.addFirst(channel);
    }
  }

  int provideChannel(List<TouchEvent> activeAndBufferedTouchEvents) {
    // print(channelQueue);
    // print(touchEvents);
    if (channelQueue.isNotEmpty) return channelQueue.removeLast();
    return _leastNotes(activeAndBufferedTouchEvents);
  }

  int _leastNotes(List<TouchEvent> touchEvents) {
    if (allMemberChannels.isEmpty) {
      throw ArgumentError('no member channels available');
    }

    final usedChans = Queue<int>.from(allMemberChannels);

    for (final event in touchEvents) {
      final removed = usedChans.remove(event.noteEvent.channel);
      if (!removed) {
        Utils.logd('touchbuffer channel not part of memberlist!');
      }
      usedChans.addFirst(event.noteEvent.channel);
    }
    return usedChans.last;
  }
}
