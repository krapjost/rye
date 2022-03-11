import 'package:flutter/material.dart';

class VoiceMailTab extends StatelessWidget {
  const VoiceMailTab({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "VoiceMail",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
