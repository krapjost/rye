import 'package:flutter/material.dart';

class TopicTab extends StatelessWidget {
  const TopicTab({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "topic list view",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
