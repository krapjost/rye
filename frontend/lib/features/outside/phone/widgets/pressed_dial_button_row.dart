import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers.dart';

class PressedDialButtonRow extends ConsumerWidget {
  const PressedDialButtonRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 300),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Consumer(builder: (context, ref, _) {
          final pressedDials = ref.watch(pressedDialProvider);
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: pressedDials,
          );
        }),
      ),
    );
  }
}
