import 'package:beat_pads/screen_pads_menu/_screen_pads_menu.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:rive/rive.dart';

import 'package:beat_pads/shared/_shared.dart';
import 'package:beat_pads/services/_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showClickToContinue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Listener(
        onPointerDown: (_) {
          Navigator.pushReplacement(
            context,
            TransitionUtils.fade(PadMenuScreen()),
          );
        },
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 10,
                child: RiveAnimation.asset(
                  'assets/anim/doggo.riv',
                  alignment: Alignment.center,
                ),
              ),
              Expanded(
                flex: 3,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        ColorizeAnimatedText(
                          'BeatPads',
                          speed: const Duration(milliseconds: 250),
                          textAlign: TextAlign.center,
                          textStyle: const TextStyle(
                            fontSize: 52.0,
                            fontFamily: 'Righteous',
                            letterSpacing: 4.0,
                            fontWeight: FontWeight.bold,
                          ),
                          colors: [
                            Palette.cadetBlue.color,
                            Palette.lightPink.color,
                            Palette.darkGrey.color,
                            Palette.yellowGreen.color,
                          ],
                        ),
                      ],
                      isRepeatingAnimation: false,
                      onFinished: () => setState(() {
                        showClickToContinue = true;
                      }),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: showClickToContinue
                    ? AnimatedTextKit(
                        isRepeatingAnimation: true,
                        repeatForever: true,
                        animatedTexts: [
                          FadeAnimatedText(
                            'Tap To Continue',
                            duration: Duration(milliseconds: 1400),
                            textStyle: TextStyle(color: Colors.black),
                          ),
                        ],
                      )
                    : Text(""),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
