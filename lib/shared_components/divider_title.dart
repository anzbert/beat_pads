import 'package:flutter/material.dart';

class DividerTitle extends StatelessWidget {
  const DividerTitle([this.title]);

  final String? title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Divider(),
      trailing: title == null
          ? null
          : Text(
              title!,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
              ),
            ),
    );
  }
}
