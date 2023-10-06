import 'package:beat_pads/screen_beat_pads/pads_and_controls.dart';
import 'package:beat_pads/screen_midi_devices/_drawer_devices.dart';
import 'package:flutter/material.dart';
import 'package:beat_pads/services/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class BeatPadsScreen extends ConsumerStatefulWidget {
//   const BeatPadsScreen({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _BeatPadsScreenState();
// }

// class _BeatPadsScreenState extends ConsumerState<BeatPadsScreen> {
//   late final AppLifecycleListener _listener;

//   @override
//   void initState() {
//     super.initState();
//     _listener = AppLifecycleListener(
//       onResume: () => () {
//         Utils.logd("check if devices still connected");
//         ref.invalidate(devicesFutureProv);
//       },
//       // onShow: () => _handleTransition('show'),
//       // onHide: () => _handleTransition('hide'),
//       // onInactive: () => _handleTransition('inactive'),
//       // onPause: () => _handleTransition('pause'),
//       // onDetach: () => _handleTransition('detach'),
//       // onRestart: () => _handleTransition('restart'),
//       // // This fires for each state change. Callbacks above fire only for
//       // // specific state transitions.
//       // onStateChange: _handleStateChange,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: Future.delayed(
//             Duration(milliseconds: Timing.screenTransitionTime), () async {
//           final bool result = await DeviceUtils.landscapeOnly();
//           await Future.delayed(
//             Duration(milliseconds: Timing.screenTransitionTime),
//           );
//           return result;
//         }),
//         builder: ((context, AsyncSnapshot<bool?> done) {
//           if (done.hasData && done.data == true) {
//             return const Scaffold(
//               body: SafeArea(
//                 child: BeatPadsAndControls(
//                   preview: false,
//                 ),
//               ),
//               drawer: Drawer(
//                 child: MidiConfig(),
//               ),
//             );
//           }
//           return const Scaffold(body: SizedBox.expand());
//         }));
//   }

//   @override
//   void dispose() {
//     _listener.dispose();
//     super.dispose();
//   }
// }

class BeatPadsScreen extends StatelessWidget {
  const BeatPadsScreen();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(
            Duration(milliseconds: Timing.screenTransitionTime), () async {
          final bool result = await DeviceUtils.landscapeOnly();
          await Future.delayed(
            Duration(milliseconds: Timing.screenTransitionTime),
          );
          return result;
        }),
        builder: ((context, AsyncSnapshot<bool?> done) {
          if (done.hasData && done.data == true) {
            return const Scaffold(
              body: SafeArea(
                child: BeatPadsAndControls(
                  preview: false,
                ),
              ),
              drawer: Drawer(
                child: MidiConfig(),
              ),
            );
          }
          return const Scaffold(body: SizedBox.expand());
        }));
  }
}
