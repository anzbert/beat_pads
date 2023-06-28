import 'package:beat_pads/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The usable sender object, which refreshes when the playmode changes
final senderProvider = Provider<PlayModeHandler>((ref) {
  /// Used to access values in notifiers within functions.
  /// Prevents the use of watch outside of build() or Providers.
  final refRead = ref.read;

  final mpeMod = SendMpe(
    ref.watch(mpe2DXProv).getMod(ref.watch(mpePitchbendRangeProv)),
    ref.watch(mpe2DYProv).getMod(ref.watch(mpePitchbendRangeProv)),
    ref.watch(mpe1DRadiusProv).getMod(ref.watch(mpePitchbendRangeProv)),
  );

  final mpeChannelGen = MPEChannelGenerator(
    memberChannels: ref.watch(mpeMemberChannelsProv),
    upperZone: ref.watch(zoneProv),
  );

  switch (ref.watch(playModeProv)) {
    case PlayMode.mpe:
      return PlayModeMPE(refRead, mpeMod, mpeChannelGen);
    case PlayMode.noPan:
      return PlayModeNoPan(refRead);
    case PlayMode.slide:
      return PlayModeSlide(refRead);
    case PlayMode.polyAT:
      return PlayModePolyAT(refRead);
  }

  // return playMode.getPlayModeApi(refRead, mpeMod, mpeChannelGen);
});

/// Handler which uses the default [PlayModeHandler] behaviour
class PlayModeNoPan extends PlayModeHandler {
  /// A basic Playmode handler, which does not react to finger panning events.
  PlayModeNoPan(super.ref);
}

abstract class PlayModeHandler {
  PlayModeHandler(this.refRead);

  /// Use this to to read the current settings in the setting Providers.
  /// Has been created to only read and prevent from accidently using
  /// ```watch``` or ```listen``` in these Handlers.
  final T Function<T>(ProviderListenable<T>) refRead;

  void handleNewTouch(PadTouchAndScreenData data) {
    if (refRead(modReleaseUsable) > 0 || refRead(noteReleaseUsable) > 0) {
      refRead(touchReleaseBuffer.notifier)
          .removeNoteFromReleaseBuffer(data.padNote);
    }

    final noteOn = NoteEvent(
      refRead(channelUsableProv),
      data.padNote,
      refRead(velocitySliderValueProv.notifier)
          .generateVelocity(data.yPercentage),
    )..noteOn(cc: refRead(sendCCProv));

    refRead(touchBuffer.notifier).addNoteOn(
      CustomPointer(data.pointer, data.screenTouchPos),
      noteOn,
      data.screenSize,
    );
  }

  void handlePan(NullableTouchAndScreenData data) {}

  void handleEndTouch(CustomPointer touch) {
    if (!refRead(touchBuffer.notifier).eventInBuffer(touch.pointer)) return;

    if (refRead(modReleaseUsable) == 0 && refRead(noteReleaseUsable) == 0) {
      refRead(touchBuffer.notifier).modifyEventWithPointerId(touch.pointer,
          (event) {
        event.noteEvent.noteOff();
      });

      refRead(touchBuffer.notifier).removeById(touch.pointer);
    } else {
      if (refRead(modReleaseUsable) == 0 && refRead(noteReleaseUsable) > 0) {
        refRead(touchBuffer.notifier).modifyEventWithPointerId(touch.pointer,
            (eventInBuffer) async {
          eventInBuffer.newPosition = eventInBuffer.origin; // mod to zero
          await refRead(touchReleaseBuffer.notifier).updateReleasedEvent(
            eventInBuffer,
          ); // instead of note off, event passed to release buffer
        });
      }
      refRead(touchBuffer.notifier).removeById(touch.pointer);
    }
  }

  void killAllNotes() {
    refRead(touchBuffer.notifier).allNotesOff();
    refRead(touchReleaseBuffer.notifier).allNotesOff();
  }

  /// Prevent further input to all currently touched notes
  void markDirty() {
    refRead(touchBuffer.notifier).markDirty();
    refRead(touchReleaseBuffer.notifier).markDirty();
  }

  /// Returns the velocity if a given note is ON in any channel.
  /// Checks releasebuffer and active touchbuffer
  int isNoteOn(int note) {
    var result = refRead(touchBuffer.notifier).isNoteOn(note);

    if (refRead(modReleaseUsable) > 0 || refRead(noteReleaseUsable) > 0) {
      if (result == 0) {
        result = refRead(touchReleaseBuffer.notifier).isNoteOn(note);
      }
    }

    return result;
  }
}
