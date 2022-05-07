import 'package:beat_pads/shared/colors.dart';
import 'package:flutter/material.dart';

/// A Card-based Info-Text Box Widget that takes an array of Strings and an optional header
class InfoBox extends StatelessWidget {
  const InfoBox({required this.body, this.header, Key? key}) : super(key: key);

  final String? header;
  final List<Widget> body;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Palette.darkGrey.color,
        margin: EdgeInsets.fromLTRB(8, 30, 8, 8),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              if (header != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        header!,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                ),
              ...body
                  .map(
                    (text) => Column(children: [
                      text,
                      SizedBox(
                        height: 8,
                      )
                    ]),
                  )
                  .toList()
            ],
          ),
        ),
      ),
    );
  }
}
