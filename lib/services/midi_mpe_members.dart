/*

// ROUND ROBBIN METHOD (probably needs overhaul)
  int _channelCycle = -1;
  int get memberChannel {
    if (playMode != PlayMode.mpe) return channel;
    int upperLimit = upperZone ? 14 : mpeMemberChannels;
    int lowerLimit = upperZone ? 15 - mpeMemberChannels : 1;

    _channelCycle = _channelCycle == -1 ? lowerLimit : _channelCycle;
    _channelCycle++;

    if (_channelCycle > upperLimit || _channelCycle < lowerLimit) {
      _channelCycle = lowerLimit;
    }
    return _channelCycle;
  }


 NOTES:
 needs to know these values:
 - currently available channels

 whenever a channel becomes available it is added to a set



FROM SPECS:
In the simplest workable implementation, a new note will be assigned to the Channel with the lowest count of active notes. Then, all else being equal, the Channel with the oldest last Note Off would be preferred. This set of rules has at least one working real-world implementation.


data structure Queue:
https://api.dart.dev/stable/2.16.1/dart-collection/Queue-class.html

- can add and remove from both ends

- add removed events to front
- remove old ones from back for new events

*/

// TODO overhaul channel MPE allocator

import 'dart:collection';

import 'package:beat_pads/services/midi_note_event.dart';

class MemberChannelDistributor {
  final bool upperZone;
  final int members;
  final _queue = Queue<int>();
  int _channelCycle = -1;

  MemberChannelDistributor(this.upperZone, this.members);

  int roundRobbin() {
    final int upperLimit = upperZone ? 14 : members;
    final int lowerLimit = upperZone ? 15 - members : 1;

    _channelCycle = _channelCycle == -1 ? lowerLimit : _channelCycle;
    _channelCycle++;

    if (_channelCycle > upperLimit || _channelCycle < lowerLimit) {
      _channelCycle = lowerLimit;
    }
    return _channelCycle;
  }

  void addChannel(NoteEvent event) {
    _queue.addFirst(event.channel);
  }

  int getChannel() {
    print(_queue);
    if (_queue.length == members) {
      print("removing last");
      return _queue.removeLast();
    }
    return roundRobbin();
  }
}
