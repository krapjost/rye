import 'package:flutter/cupertino.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:rye/app/ui/profile/profile_page.dart';
import 'package:rye/app/ui/phone/phone_page.dart';

List<Widget> pages = [
  PhonePage(),
  Center(
      child:
          Container(child: Text("asd", style: TextStyle(color: Colors.white)))),
];

class RootRouter extends StatefulWidget {
  const RootRouter({Key? key}) : super(key: key);

  @override
  RootRouterState createState() => RootRouterState();
}

class RootRouterState extends State<RootRouter> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        title: CircleRoute(_page),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: PageView(
        onPageChanged: (index) {
          if (mounted)
            setState(() {
              _page = index;
            });
        },
        scrollDirection: Axis.vertical,
        children: pages,
      ),
    );
  }
}

class CircleRoute extends StatefulWidget {
  final int _page;
  CircleRoute(this._page);

  @override
  State<CircleRoute> createState() => _CircleRouteState();
}

class _CircleRouteState extends State<CircleRoute>
    with SingleTickerProviderStateMixin {
  Animation<double>? _animation;
  AnimationController? _controller;
  double _gap = 13.0;
  double _rad = 0.0;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);

    _controller!
      ..forward()
      ..addStatusListener((status) {
        print("$status");
        if (status == AnimationStatus.completed) {
          _controller!.stop();
        } else if (status == AnimationStatus.dismissed) {}
      });

    _animation = Tween(begin: 0.0, end: _gap)
        .animate(_controller!.drive(CurveTween(curve: Curves.ease)))
      ..addListener(() {
        setState(() {
          _rad = _animation!.value;
        });
      });
  }

  @override
  void didUpdateWidget(covariant CircleRoute oldWidget) {
    print("changed? cur=${widget._page}, old=${oldWidget._page}");
    if (widget._page == 0) {
      print("0");
      _controller?.forward();
    } else {
      print("1");
      _controller?.reverse();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return CustomPaint(
      size: Size(size.width, size.height),
      painter: CirclePainter(_rad),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double rad;
  var stroke;

  CirclePainter(this.rad) {
    stroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2.0;
    double centerY = size.height / 2.0;

    final double maxRad = 13;
    double curRad = rad;
    while (curRad <= maxRad) {
      canvas.drawCircle(Offset(centerX, centerY), curRad, stroke);
      curRad += 3;
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}
