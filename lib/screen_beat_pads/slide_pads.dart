import 'package:beat_pads/screen_beat_pads/slide_pad.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:beat_pads/shared/_shared.dart';
import 'package:beat_pads/services/_services.dart';

// TODO: prototype of slidable pads

class SlidePads extends StatefulWidget {
  const SlidePads({Key? key}) : super(key: key);

  @override
  State<SlidePads> createState() => _SlidePadsState();
}

class _SlidePadsState extends State<SlidePads> {
  final GlobalKey _padsWidgetKey = GlobalKey();
  int? _selectedPad;

  void _detectTappedItem(PointerEvent event) {
    final RenderBox box = _padsWidgetKey.currentContext!
        .findAncestorRenderObjectOfType<RenderBox>()!;
    final Offset localOffset = box.globalToLocal(event.position);
    final BoxHitTestResult results = BoxHitTestResult();

    if (box.hitTest(results, position: localOffset)) {
      for (final HitTestEntry<HitTestTarget> hit in results.path) {
        final HitTestTarget target = hit.target;
        if (target is TestProxyBox) {
          setState(() => _selectedPad = target.index);
        }
      }
    }
  }

  void _clearSelection(PointerUpEvent event) {
    setState(() => _selectedPad = null);
  }

  @override
  Widget build(BuildContext context) {
    final List<List<int>> rowsList =
        Provider.of<Settings>(context, listen: true).rows;

    Provider.of<MidiData>(context, listen: false).channel =
        Provider.of<Settings>(context, listen: true).channel - 1;

    return Listener(
      onPointerDown: _detectTappedItem,
      onPointerMove: mounted || _selectedPad != null ? _detectTappedItem : null,
      onPointerUp: mounted ? _clearSelection : null,
      child: Column(
        // Hit testing happens on this keyed Widget, which contains all the pads!
        key: _padsWidgetKey,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...rowsList.map((row) {
            return Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ...row.map((note) {
                    return Expanded(
                      flex: 1,
                      child: TestObject(
                        index: note,
                        child: SlideBeatPad(
                            note: note, selected: note == _selectedPad),
                      ),
                    );
                  }).toList()
                ],
              ),
            );
          }).toList()
        ],
      ),
    );
  }
}
