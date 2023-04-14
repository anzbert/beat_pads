// ignore_for_file: require_trailing_commas

import 'dart:collection';
import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

/*
FROM SPECS:
In the simplest workable implementation, a new note will be assigned to the 
Channel with the lowest count of active notes. Then, all else being equal, 
the Channel with the oldest last Note Off would be preferred. This set of 
rules has at least one working real-world implementation.
*/

final mpeChannelProv = AutoDisposeNotifierProvider<MemberChannelProvider, int>(
  MemberChannelProvider.new,
);

class MemberChannelProvider extends AutoDisposeNotifier<int> {
  Queue<int> channelQueue = Queue();
  List<int> allMemberChannels = [];

  @override
  int build() {
    allMemberChannels = List.generate(
        ref.read(mpeMemberChannelsProv),
        (i) =>
            i +
            (ref.watch(zoneProv) ? 15 - ref.watch(mpeMemberChannelsProv) : 1),
        growable: false);
    channelQueue = Queue.from(allMemberChannels);

    return 0;
  }

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

    final Queue<int> usedChans = Queue.from(allMemberChannels);

    for (final TouchEvent event in touchEvents) {
      final bool removed = usedChans.remove(event.noteEvent.channel);
      if (!removed) {
        Utils.logd('touchbuffer channel not part of memberlist!');
      }
      usedChans.addFirst(event.noteEvent.channel);
    }
    return usedChans.last;
  }
}
