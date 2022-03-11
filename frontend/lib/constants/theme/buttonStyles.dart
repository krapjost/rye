import 'package:flutter/material.dart';
import 'colors.dart';

class RyeButton {
  static final ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
    primary: Colors.black87,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  static Color getButtonColor(Set<MaterialState> states) {
    Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return DarkThemeColor.SECONDARY.withOpacity(0.9);
    }
    return DarkThemeColor.SECONDARY;
  }

  static Color getTransparentButtonColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return DarkThemeColor.SECONDARY.withOpacity(0.5);
    }
    return Colors.transparent;
  }

  static Color getOverlayColorOfButton(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return DarkThemeColor.SECONDARY;
    }
    return Colors.transparent;
  }

  static Color getOverlayColorOfTransparentButton(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return DarkThemeColor.SECONDARY.withOpacity(0.3);
    }
    return Colors.transparent;
  }

  static BorderSide getButtonBorderSideColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return BorderSide(color: DarkThemeColor.SECONDARY);
    }
    return BorderSide(color: DarkThemeColor.POINT);
  }
}
