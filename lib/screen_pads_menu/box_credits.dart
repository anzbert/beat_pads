import 'package:beat_pads/shared_components/_shared.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:beat_pads/services/services.dart';

class CreditsBox extends StatelessWidget {
  const CreditsBox({Key? key}) : super(key: key);

  Future<bool> webView(String host, [String? path]) async {
    final httpUri = Uri(
      scheme: 'https',
      host: host,
      path: path,
    );
    if (await canLaunchUrl(httpUri)) {
      return await launchUrl(httpUri);
    } else {
      Utils.logd("Failure to launch webview with:\n$httpUri");
      return false;
    }
  }

  final double _linkFontSize = 18;

  @override
  Widget build(BuildContext context) {
    return WidgetsInfoBox(
      header: "Credits",
      body: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(children: const [
              Text("Get the Source, contribute and report issues:"),
            ]),
            TextButton(
              child: Text(
                "GitHub",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: _linkFontSize),
              ),
              onPressed: () async =>
                  await webView("github.com", "anzbert/beat_pads"),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(children: const [Text("My website:")]),
            TextButton(
              child: Text(
                "Anzio.dev",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: _linkFontSize),
              ),
              onPressed: () async => await webView("anzio.dev"),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(children: const [Text("Magic Tone Network & XpressPads:")]),
            TextButton(
              child: Text(
                "XpressPads.com",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: _linkFontSize),
              ),
              onPressed: () async => await webView("xpresspads.com"),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(children: const [Text("Dog Logo by 'catalyststuff' from:")]),
            TextButton(
              child: Text(
                "FreePik.com",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: _linkFontSize),
              ),
              onPressed: () async => await webView("freepik.com"),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(children: const [Text("Splash Screen animated with Rive:")]),
            TextButton(
              child: Text("Rive.app",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: _linkFontSize)),
              onPressed: () async => await webView("rive.app"),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: const [Text("Contact me:")],
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
                if (await canLaunchUrl(encoded)) {
                  await launchUrl(encoded);
                } else {
                  Utils.logd("Failure to launch webview with:\n$encoded");
                }
              },
            )
          ],
        ),
      ],
    );
  }
}
