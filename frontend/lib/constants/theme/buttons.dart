import 'package:flutter/material.dart';
import 'colors.dart';

class B {
  static const ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
  primary: Colors.black87,
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);

  static const Color getButtonColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return C.BROWN.withOpacity(0.9);
    }
    return C.BROWN;
  }
  
  static const Color getTransparentButtonColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return C.BROWN.withOpacity(0.5);
    }
    return Colors.transparent;
  }
  static const Color getOverlayColorOfButton(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return C.POINT2;
    }
    return Colors.transparent;
  }
  static const Color getOverlayColorOfTransparentButton(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return C.BROWN.withOpacity(0.3);
    }
    return Colors.transparent;
  }
  static const BorderSide getButtonBorderSideColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return BorderSide(color: C.GREY800);
    }
    return BorderSide(color: C.POINT2);
  }
}

