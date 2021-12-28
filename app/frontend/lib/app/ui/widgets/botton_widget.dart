import 'package:flutter/material.dart';

class RaisedButtonCustomWidget extends StatelessWidget {
  final IconData icon;
  final String? text;
  final void Function()? onPressed;
  final Color? borderColor;
  RaisedButtonCustomWidget(
      {required this.icon,
      required this.onPressed,
      this.text,
      this.borderColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: this.onPressed,
      child: Icon(
        this.icon,
        color: Colors.white,
      ),
    );
  }
}
