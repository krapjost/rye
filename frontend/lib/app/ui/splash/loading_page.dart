import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rye/app/ui/theme/app_colors.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.GREY800,
      child: SpinKitSpinningCircle(
        color: Palette.POINT2,
        size: 80.0,
      ),
    );
  }
}
