import 'package:flutter/material.dart';

class Palette {
  static const RYE = Color.fromRGBO(249, 195, 112, 1);
  static const BG = Color.fromRGBO(243, 239, 236, 1);
  static const BROWN = Color.fromRGBO(51, 43, 41, 1);
  static const GREY800 = Color.fromRGBO(51, 51, 51, 1);
  static const GREY600 = Color.fromRGBO(117, 117, 117, 1);
  static const GREY400 = Color.fromRGBO(189, 189, 189, 1);
  static const FILTER = Color.fromRGBO(59, 50, 43, 0.2);
  static const WOOD800 = Color.fromRGBO(31, 21, 12, 1);
  static const WHITEFILTER = Color.fromRGBO(255, 255, 255, 0.5);
  static const POINT1 = Color.fromRGBO(255, 94, 98, 1);
  static const POINT2 = Color.fromRGBO(255, 153, 102, 1);

  static Color getButtonColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Palette.BROWN.withOpacity(0.9);
    }
    return Palette.BROWN;
  }

  static Color getTransparentButtonColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Palette.BROWN.withOpacity(0.5);
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
      return Palette.POINT2;
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
      return Palette.BROWN.withOpacity(0.3);
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
      return BorderSide(color: Palette.GREY800);
    }
    return BorderSide(color: Palette.POINT2);
  }
}

final Color textColor = Palette.GREY800;
