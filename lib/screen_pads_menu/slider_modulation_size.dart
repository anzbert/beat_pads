import 'package:beat_pads/screen_pads_menu/menu_advanced.dart';
import 'package:beat_pads/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModSizeSliderTile extends ConsumerWidget {
  const ModSizeSliderTile({
    required this.setValue,
    required this.readValue,
    required this.trailing,
    this.label = '#label',
    this.subtitle,
    this.min = 0,
    this.max = 1,
    this.resetValue,
    this.onChangeEnd,
    super.key,
  });

  final String label;
  final String? subtitle;
  final double min;
  final double max;
  final double readValue;
  final Widget trailing;
  final void Function(double) setValue;
  final void Function()? onChangeEnd;
  final void Function()? resetValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Row(
              children: [
                Text(label),
                if (resetValue != null)
                  TextButton(
                    onPressed: () {
                      resetValue!();
                      ref.read(showModPreview.notifier).state = true;
                      Future.delayed(const Duration(milliseconds: 800), () {
                        if (context.mounted) {
                          ref.read(showModPreview.notifier).state = false;
                        }
                      });
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Reset'),
                  )
              ],
            ),
            subtitle: subtitle != null ? Text(subtitle!) : null,
            trailing: trailing,
          ),
          Builder(
            builder: (context) {
              final width = MediaQuery.of(context).size.width;
              return SizedBox(
                width: width * ThemeConst.sliderWidthFactor,
                child: Slider(
                  min: min,
                  max: max,
                  value: readValue.clamp(min, max),
                  onChanged: setValue,
                  onChangeStart: (_) =>
                      ref.read(showModPreview.notifier).state = true,
                  onChangeEnd: (_) {
                    ref.read(showModPreview.notifier).state = false;
                    onChangeEnd?.call();
                  },
                ),
              );
            },
          ),
        ],
      );
}
