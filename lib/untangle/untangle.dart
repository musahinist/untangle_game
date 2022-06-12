import 'package:flutter/material.dart';

class Untangle extends StatefulWidget {
  const Untangle({Key? key}) : super(key: key);
  static const String routeName = 'Untangle';

  @override
  State<Untangle> createState() => _UntangleState();
}

class _UntangleState extends State<Untangle> {
  List<Offset> lines = [
    const Offset(36, 36),
    const Offset(200, 200),
    const Offset(24, 150),
    const Offset(150, 30),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Untangle'),
      ),
      body: Center(
        child: Listener(
          onPointerMove: (e) {
            lines[0] = e.localPosition;
            setState(() {});
          },
          child: SizedBox(
              width: 240,
              height: 240,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CustomPaint(
                    painter: _LinePainter(lines, color: Colors.blue),
                  ),
                  for (var i = 0; i < lines.length; i++)
                    Positioned(
                        left: lines[i].dx - 12,
                        top: lines[i].dy - 12,
                        child: const CircleAvatar(
                          radius: 12,
                        ))
                ],
              )),
        ),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<Offset> points;
  final Color? color;
  _LinePainter(this.points, {this.color = Colors.black});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..strokeWidth = 8
      ..color = color!
      ..strokeCap = StrokeCap.round;
    if (intersect(points)) paint.color = Colors.red;

    if (points.length > 1) {
      for (var i = 0; i < points.length - 1; i = i + 2) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

//http://paulbourke.net/geometry/pointlineplane/
  bool intersect(List<Offset> p) {
    // Check if none of the lines are of length 0
    if ((p[0].dx == p[1].dx && p[0].dy == p[1].dy) ||
        (p[2].dx == p[3].dx && p[2].dy == p[3].dy)) {
      return false;
    }

    double denominator = ((p[3].dy - p[2].dy) * (p[1].dx - p[0].dx) -
        (p[3].dx - p[2].dx) * (p[1].dy - p[0].dy));

    // Lines are parallel
    if (denominator == 0) {
      return false;
    }

    double ua = ((p[3].dx - p[2].dx) * (p[0].dy - p[2].dy) -
            (p[3].dy - p[2].dy) * (p[0].dx - p[2].dx)) /
        denominator;
    double ub = ((p[1].dx - p[0].dx) * (p[0].dy - p[2].dy) -
            (p[1].dy - p[0].dy) * (p[0].dx - p[2].dx)) /
        denominator;

    // is the intersection along the segments
    if (ua < 0 || ua > 1 || ub < 0 || ub > 1) {
      return false;
    }

    // Return a object with the x and y coordinates of the intersection
    // double x = x1 + ua * (x2 - x1);
    // double y = y1 + ua * (y2 - y1);

    return true; //{x, y}
  }

  @override
  bool shouldRepaint(_LinePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(_LinePainter oldDelegate) => true;
}
