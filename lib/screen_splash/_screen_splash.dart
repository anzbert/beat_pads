import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:beat_pads/screen_pads_menu/_screen_pads_menu.dart';
import 'package:beat_pads/services/services.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showClickToContinue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          MediaQuery.of(context).platformBrightness == Brightness.light
              ? const HSLColor.fromAHSL(1, 240, 0.1, 0.99).toColor()
              : Palette.menuHeaders,
      body: Listener(
        onPointerDown: (_) {
          Navigator.push(
            context,
            TransitionUtils.fade(const PadMenuScreen()),
          );
        },
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            curve: Curves.ease,
            duration: const Duration(
              milliseconds: 250,
            ), // Fade in Splash Screen Content
            builder: (
              BuildContext context,
              double opacityTweenValue,
              Widget? child,
            ) {
              return Opacity(
                opacity: opacityTweenValue,
                child: Column(
                  children: [
                    const Expanded(
                      flex: 10,
                      child: RiveAnimation.asset(
                        'assets/anim/doggo.riv',
                        alignment: Alignment.center,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              ColorizeAnimatedText(
                                'Midi Poly Grid',
                                speed: const Duration(milliseconds: 250),
                                textAlign: TextAlign.center,
                                textStyle: const TextStyle(
                                  fontSize: 52,
                                  fontFamily: 'Righteous',
                                  letterSpacing: 4,
                                  fontWeight: FontWeight.bold,
                                ),
                                colors: [
                                  Palette.cadetBlue,
                                  Palette.lightPink,
                                  Palette.darkGrey,
                                  Palette.yellowGreen,
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
                      child: showClickToContinue
                          ? AnimatedTextKit(
                              repeatForever: true,
                              animatedTexts: [
                                FadeAnimatedText(
                                  'Tap To Continue',
                                  duration: const Duration(milliseconds: 1400),
                                  textStyle: MediaQuery.of(context)
                                              .platformBrightness ==
                                          Brightness.light
                                      ? const TextStyle(color: Colors.black)
                                      : TextStyle(color: Palette.whiteLike),
                                ),
                              ],
                            )
                          : const Text(''),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
