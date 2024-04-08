import 'package:flutter/material.dart';

/// A Card-based Info-Text Box Widget that takes an array of Strings and an optional header
class StringInfoBox extends StatelessWidget {
  const StringInfoBox({required this.body, this.header, super.key});

  final String? header;
  final List<String> body;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (header != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Divider(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 12),
                        child: Text(
                          header!,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ...body.map(
                (text) => Column(
                  children: [
                    Text(text),
                    const SizedBox(
                      height: 5,
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
