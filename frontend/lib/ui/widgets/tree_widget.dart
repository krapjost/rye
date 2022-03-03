import 'package:flutter/material.dart';

class TreeModel {
  final int leaves;
  final int branches;
  final String subject;
  final List<String>? contributors;

  const TreeModel({
    required this.leaves,
    required this.branches,
    required this.subject,
    this.contributors,
  });
}

final rootSubjects = [
  "music",
  "computer",
  "drawing",
];

final testTreeData = {
  "root": {
    "topic": "knowledge",
    "branches": [
      {
        "title": "computer",
        "created_by": "henlydkdk",
        "created_at": "2020-02-30",
        "followers": ["heyhey", "henlydkdk", "discdics"],
        "content": "this is howho dododododododododo awodjawodj",
        "leaves": [
          {
            "title": "network",
            "created_by": "hellowowow",
            "created_at": "2020-01-30",
            "followers": ["hoho", "howo", "disdad"],
          },
          {
            "title": "algorithm",
            "created_by": "hellowowow",
            "created_at": "2020-01-30",
            "followers": ["hoho", "howo", "disdad"],
          },
        ],
      },
      {
        "title": "music",
        "created_by": "henlydkdk",
        "created_at": "2020-02-30",
        "followers": ["heyhey", "henlydkdk", "discdics"],
        "leaves": [
          {
            "title": "hwauhm",
            "created_by": "hellowowow",
            "created_at": "2020-01-30",
            "followers": ["hoho", "howo", "disdad"],
          },
          {
            "title": "login",
            "created_by": "hellowowow",
            "created_at": "2020-01-30",
            "followers": ["hoho", "howo", "disdad"],
          },
        ]
      }
    ]
  }
};

final TreeModel testTree = TreeModel(
    leaves: 2, branches: 4, subject: 'asd', contributors: ['holede', 'deded']);

class TreePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var line = Paint();
    var bottomCenter = Offset(size.width / 2, size.height);
    var center = Offset(size.width / 2, size.height / 2);
    line..strokeWidth = 3;
    line.color = Colors.black87;
    canvas.drawLine(bottomCenter, center, line);

    var oval = Paint();
    oval.color = Colors.yellow;
    canvas.drawOval(
        Rect.fromCenter(center: center, width: 10.0, height: 10.0), oval);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class treeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white60,
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.8,
      child: CustomPaint(
        painter: TreePainter(),
      ),
    );
  }
}
