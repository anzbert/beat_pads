import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/shared_components/_shared.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsBox extends StatelessWidget {
  const CreditsBox({super.key});

  Future<bool> webView(String host, [String? path]) async {
    final httpUri = Uri(
      scheme: 'http',
      host: host,
      path: path,
    );
    if (await canLaunchUrl(httpUri)) {
      return launchUrl(httpUri);
    } else {
      Utils.logd('Failure to launch webview with:\n$httpUri');
      return false;
    }
  }

  static const double _linkFontSize = 18;

  @override
  Widget build(BuildContext context) {
    return WidgetsInfoBox(
      header: 'Links',
      body: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Wrap(
              children: [
                Text('Get the Source, contribute and report issues:'),
              ],
            ),
            TextButton(
              child: const Text(
                'GitHub',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: _linkFontSize,
                ),
              ),
              onPressed: () async => webView('github.com', 'anzbert/beat_pads'),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Wrap(children: [Text('My website:')]),
            TextButton(
              child: const Text(
                'Anzio.dev',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: _linkFontSize,
                ),
              ),
              onPressed: () async => webView('anzio.dev'),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Wrap(children: [Text('Magic Tone Network & XpressPads:')]),
            TextButton(
              child: const Text(
                'XpressPads.com',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: _linkFontSize,
                ),
              ),
              onPressed: () async => webView('xpresspads.com'),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Wrap(children: [Text("Dog Logo by 'catalyststuff' from:")]),
            TextButton(
              child: const Text(
                'FreePik.com',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: _linkFontSize,
                ),
              ),
              onPressed: () async => webView('freepik.com'),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Wrap(children: [Text('Splash Screen animated with Rive:')]),
            TextButton(
              child: const Text(
                'Rive.app',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: _linkFontSize,
                ),
              ),
              onPressed: () async => webView('rive.app'),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Wrap(
              children: [Text('Contact me:')],
            ),
            TextButton(
              child: const Text(
                'anzbert@gmail.com',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: _linkFontSize,
                ),
              ),
              onPressed: () async {
                final Uri encoded = Uri(
                  scheme: 'mailto',
                  path: 'anzbert@gmail.com',
                  query:
                      'subject=App Feedback&body=Feedback for Midi Poly Grid', //add subject and body here
                );
                if (await canLaunchUrl(encoded)) {
                  await launchUrl(encoded);
                } else {
                  Utils.logd('Failure to launch webview with:\n$encoded');
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
