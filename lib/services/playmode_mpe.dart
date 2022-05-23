import 'package:beat_pads/services/services.dart';

class PlayModeMPE extends PlayModeApi {
  PlayModeMPE(super.settings, super.screenSize, super.notifyParent);

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  void handleEndTouch(CustomPointer touch) {
    // TODO: implement handleEndTouch
  }

  @override
  void handleNewTouch(CustomPointer touch, int noteTapped) {
    // TODO: implement handleNewTouch
  }

  @override
  void handlePan(CustomPointer touch, int? note) {
    // TODO: implement handlePan
  }
}
