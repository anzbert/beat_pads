// import 'package:beat_pads/services/transition_utils.dart';
// import 'package:flutter/material.dart';

// import 'package:beat_pads/shared/_shared.dart';
// import 'package:beat_pads/screen_home/_screen_home.dart';

// class FloatingButtonPads extends StatelessWidget {
//   const FloatingButtonPads({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton.large(
//       heroTag: "toPads",
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(
//           Radius.circular(10),
//         ),
//       ),
//       elevation: 20,
//       highlightElevation: 0,
//       backgroundColor: Palette.whiteLike.color.withAlpha(60),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Image.asset("assets/logo/logo_noframe.png"),
//       ),
//       onPressed: () => Navigator.of(context)
//           .push(TransitionUtils.verticalSlide(const HomeScreen())),
//     );
//   }
// }
