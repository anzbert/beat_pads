import 'package:flutter/material.dart';

class DividerTitle extends StatelessWidget {
  const DividerTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Divider(),
      trailing: Text(
        title,
        style: TextStyle(
            fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize),
      ),
    );
  }
}
