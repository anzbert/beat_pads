import 'package:beat_pads/screens/config_screen.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

// import './config_screen.dart';

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
            // MaterialPageRoute(builder: (context) => HomeScreen()),
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => ConfigScreen(),
              transitionsBuilder: (c, anim, a2, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 250),
            ),
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 10,
                child: RiveAnimation.asset(
                  'assets/anim/doggo2.riv',
                  alignment: Alignment.bottomCenter,
                ),
              ),
              Expanded(
                flex: 5,
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
                        Colors.purple,
                        Colors.green,
                        Colors.purple,
                        Colors.green
                      ],
                    ),
                  ],
                  isRepeatingAnimation: false,
                  onFinished: () => setState(() {
                    showClickToContinue = true;
                  }),
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
