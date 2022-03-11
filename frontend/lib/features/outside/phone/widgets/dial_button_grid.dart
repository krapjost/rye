import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import '../providers.dart';

List<Widget> topicButtons = [
  Icon(
    LineIcons.book,
    size: 42,
    color: Colors.white,
  ),
  Icon(
    LineIcons.dna,
    size: 42,
    color: Colors.white,
  ),
  Icon(
    LineIcons.film,
    size: 42,
    color: Colors.white,
  ),
  Icon(
    LineIcons.bicycle,
    size: 42,
    color: Colors.white,
  ),
  Icon(
    LineIcons.heart,
    size: 42,
    color: Colors.white,
  ),
  Icon(
    LineIcons.gamepad,
    size: 42,
    color: Colors.white,
  ),
  Icon(
    LineIcons.music,
    size: 42,
    color: Colors.white,
  ),
  Icon(
    LineIcons.circle,
    size: 42,
    color: Colors.white38,
  ),
  Icon(
    LineIcons.circle,
    size: 42,
    color: Colors.white38,
  ),
  Icon(
    LineIcons.random,
    size: 42 * 0.7,
    color: Colors.brown.shade400,
  ),
  Icon(
    LineIcons.circle,
    size: 42,
    color: Colors.white38,
  ),
  Icon(
    LineIcons.hashtag,
    size: 42 * 0.7,
    color: Colors.brown.shade400,
  ),
];

class DialButtonGrid extends ConsumerWidget {
  const DialButtonGrid({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 300,
        maxHeight: 340,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: 12,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1 / 0.8,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Ink(
            padding: EdgeInsets.all(3),
            height: 28,
            width: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ), // LinearGradientBoxDecoration
            child: InkWell(
              highlightColor: Colors.white,
              onTap: () {
                List<Widget> dials = ref.read(pressedDialProvider);
                ref.read(pressedDialProvider.state).state = [
                  ...dials,
                  topicButtons[index]
                ];
              },
              onLongPress: () {
                print("add topic");
              },
              customBorder: CircleBorder(),
              child: topicButtons[index],
            ),
          );
        },
      ),
    );
  }
}
