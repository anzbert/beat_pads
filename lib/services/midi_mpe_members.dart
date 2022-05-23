/*
FROM SPECS:
In the simplest workable implementation, a new note will be assigned to the Channel with the lowest count of active notes. Then, all else being equal, the Channel with the oldest last Note Off would be preferred. This set of rules has at least one working real-world implementation.
*/

import 'dart:collection';
import 'package:beat_pads/services/services.dart';

class MemberChannelProvider {
  final bool upperZone;
  final int members;

  final List<int> allMemberChannels;
  final Queue<int> channelQueue;

  MemberChannelProvider(this.upperZone, this.members)
      : allMemberChannels = List.generate(
            members, (i) => i + (upperZone ? 15 - members : 1),
            growable: false),
        channelQueue = Queue.from(
            List.generate(members, (i) => i + (upperZone ? 15 - members : 1)));

  void releaseChannel(NoteEvent event) {
    if (!channelQueue.contains(event.channel)) {
      channelQueue.addFirst(event.channel);
    }
  }

  int provideChannel(List<TouchEvent> touchEvents) {
    // int touchLength = touchEvents.length;
    if (channelQueue.isNotEmpty) return channelQueue.removeLast();
    return leastNotes(touchEvents);
  }

  int leastNotes(List<TouchEvent> touchEvents) {
    if (allMemberChannels.isEmpty) throw ("no member channels available");

    Queue<int> usedChans = Queue.from(allMemberChannels);

    for (TouchEvent event in touchEvents) {
      bool removed = usedChans.remove(event.noteEvent.channel);
      if (!removed) {
        Utils.logd("touchbuffer channel not part of memberlist!");
      }
      usedChans.addFirst(event.noteEvent.channel);
    }
    return usedChans.last;
  }
}
