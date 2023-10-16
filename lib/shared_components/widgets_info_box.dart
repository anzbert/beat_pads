import 'package:beat_pads/services/services.dart';
import 'package:beat_pads/shared_components/divider_title.dart';
import 'package:flutter/material.dart';

/// A Card-based Info-Text Box Widget that takes an array of Widgets and an optional header
class WidgetsInfoBox extends StatelessWidget {
  const WidgetsInfoBox({required this.body, this.header, super.key});

  final String? header;
  final List<Widget> body;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Palette.darkGrey,
        margin: const EdgeInsets.fromLTRB(8, 30, 8, 8),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (header != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DividerTitle(header!),
                ),
              ...body.map(
                (text) => Column(
                  children: [
                    text,
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
