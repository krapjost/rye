import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import '../providers.dart';

class InteractionButtonRow extends HookConsumerWidget {
  const InteractionButtonRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pressedDial = ref.watch(pressedDialProvider.state).state;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 300),
      child: Container(
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 60,
              height: 60,
            ),
            Ink(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.brown.shade800,
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: () {
                    print('to call page');
                  },
                  customBorder: CircleBorder(),
                  child: Icon(LineIcons.phone, color: Colors.white, size: 34),
                )),
            pressedDial.length > 1
                ? Ink(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ), // LinearGradientBoxDecoration
                    child: InkWell(
                      onTap: () {
                        List<Widget> dials = ref.read(pressedDialProvider);
                        dials.removeLast();
                        ref.read(pressedDialProvider.state).state = [...dials];
                      },
                      onLongPress: () {
                        ref.read(pressedDialProvider.state).state = [
                          SizedBox()
                        ];
                      },
                      customBorder: CircleBorder(
                          side: BorderSide(
                              width: 2,
                              color: Colors.white,
                              style: BorderStyle.solid)),
                      child:
                          Icon(LineIcons.times, color: Colors.white, size: 20),
                    ),
                  )
                : SizedBox(width: 60, height: 60),
          ],
        ),
      ),
    );
  }
}
