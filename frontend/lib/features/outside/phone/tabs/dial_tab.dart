import 'package:flutter/material.dart';
import 'package:rye/features/outside/phone/widgets/dial_button_grid.dart';
import 'package:rye/features/outside/phone/widgets/interaction_button_row.dart';
import 'package:rye/features/outside/phone/widgets/pressed_dial_button_row.dart';

class DialTab extends StatelessWidget {
  const DialTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PressedDialButtonRow(),
          SizedBox(height: 30),
          DialButtonGrid(),
          InteractionButtonRow(),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
