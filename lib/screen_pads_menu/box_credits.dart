import 'package:beat_pads/shared_components/_shared.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:beat_pads/services/_services.dart';

class CreditsBox extends StatelessWidget {
  const CreditsBox({Key? key}) : super(key: key);

  Future<bool> webView(String url) async {
    Uri uri = Uri.dataFromString(url);
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    } else {
      Utils.logd("Failure to launch webview with:\n$url");
      return false;
    }
  }

  final double _linkFontSize = 18;

  @override
  Widget build(BuildContext context) {
    return InfoBox(
      header: "Credits",
      body: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(children: const [Text("Made by A. Mueller")]),
            TextButton(
              child: Text(
                "Anzio.dev",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: _linkFontSize),
              ),
              onPressed: () async => await webView("https://www.anzio.dev"),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(children: const [
              Text("Magic Tone Network / XpressPads by A. Samek")
            ]),
            TextButton(
              child: Text(
                "XpressPads.com",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: _linkFontSize),
              ),
              onPressed: () async =>
                  await webView("https://www.xpresspads.com"),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(children: const [Text("Dog Icon by 'catalyststuff'")]),
            TextButton(
              child: Text(
                "FreePik.com",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: _linkFontSize),
              ),
              onPressed: () async => await webView("https://www.freepik.com"),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(children: const [Text("Logo Animated with Rive")]),
            TextButton(
              child: Text("Rive.app",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: _linkFontSize)),
              onPressed: () async => await webView("https://www.rive.app"),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: const [Text("Please send improvement suggestions to")],
            ),
            TextButton(
              child: Text(
                "anzbert@gmail.com",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: _linkFontSize),
              ),
              onPressed: () async {
                final Uri encoded = Uri(
                  scheme: 'mailto',
                  path: 'anzbert@gmail.com',
                  query:
                      'subject=App Feedback&body=Feedback for Beat pads', //add subject and body here
                );
                await webView(encoded.toString());
              },
            )
          ],
        ),
      ],
    );
  }
}
