import 'dart:collection';
import 'package:beat_pads/services/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

/*
FROM SPECS:
In the simplest workable implementation, a new note will be assigned to the Channel with the lowest count of active notes. Then, all else being equal, the Channel with the oldest last Note Off would be preferred. This set of rules has at least one working real-world implementation.
*/

// TODO decouple this!!

// final _allMemberChannels = Provider<List<int>>((ref) {
//   return List.generate(
//       ref.watch(mpeMemberChannelsProv),
//       (i) =>
//           i + (ref.watch(zoneProv) ? 15 - ref.watch(mpeMemberChannelsProv) : 1),
//       growable: false);
// });

// final channelQueue = StateNotifierProvider<MPEChannelNotifier, int>((ref) {
//   return MPEChannelNotifier(ref.watch(_allMemberChannels));
// });

// class MPEChannelNotifier extends StateNotifier<int> {
//   final Queue<int> channelQueue;
//   final List<int> allMemberChannels;

//   MPEChannelNotifier(this.allMemberChannels)
//       : channelQueue = Queue.from(allMemberChannels),
//         super(allMemberChannels.last);

//   void releaseMPEChannel(int channel) {
//     if (!channelQueue.contains(channel)) {
//       channelQueue.addFirst(channel);
//     }
//   }

//   void generateChannel(List<TouchEvent> touchEvents) {
//     if (channelQueue.isNotEmpty) {
//       state = channelQueue.removeLast();
//     } else {
//       state = leastNotes(touchEvents);
//     }
//   }

//   int leastNotes(List<TouchEvent> touchEvents) {
//     if (allMemberChannels.isEmpty) throw ("no member channels available");

//     Queue<int> usedChans = Queue.from(allMemberChannels);

//     for (TouchEvent event in touchEvents) {
//       bool removed = usedChans.remove(event.noteEvent.channel);
//       if (!removed) {
//         Utils.logd("touchbuffer channel not part of memberlist!");
//       }
//       usedChans.addFirst(event.noteEvent.channel);
//     }
//     return usedChans.last;
//   }
// }

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

  void releaseMPEChannel(int channel) {
    if (!channelQueue.contains(channel)) {
      channelQueue.addFirst(channel);
    }
  }

  int provideChannel(List<TouchEvent> activeAndBufferedTouchEvents) {
    // print(channelQueue);
    // print(touchEvents);
    if (channelQueue.isNotEmpty) return channelQueue.removeLast();
    return leastNotes(activeAndBufferedTouchEvents);
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
