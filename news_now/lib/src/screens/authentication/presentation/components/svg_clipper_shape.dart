import 'package:flutter/material.dart';

class MariasClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double xScaling = size.width / 414;
    final double yScaling = size.height / 896;
    path.lineTo(67 * xScaling, 20.7 * yScaling);
    path.cubicTo(
      73.7 * xScaling,
      24.5 * yScaling,
      82.1 * xScaling,
      25.6 * yScaling,
      86.6 * xScaling,
      30 * yScaling,
    );
    path.cubicTo(
      91 * xScaling,
      34.4 * yScaling,
      91.5 * xScaling,
      42.2 * yScaling,
      89.6 * xScaling,
      48.9 * yScaling,
    );
    path.cubicTo(
      87.8 * xScaling,
      55.6 * yScaling,
      83.5 * xScaling,
      61.3 * yScaling,
      80.3 * xScaling,
      67.7 * yScaling,
    );
    path.cubicTo(
      77 * xScaling,
      74.2 * yScaling,
      74.7 * xScaling,
      81.5 * yScaling,
      69.8 * xScaling,
      86.8 * yScaling,
    );
    path.cubicTo(
      64.9 * xScaling,
      92.1 * yScaling,
      57.5 * xScaling,
      95.4 * yScaling,
      50.4 * xScaling,
      94.7 * yScaling,
    );
    path.cubicTo(
      43.4 * xScaling,
      94 * yScaling,
      36.8 * xScaling,
      89.2 * yScaling,
      31.9 * xScaling,
      83.9 * yScaling,
    );
    path.cubicTo(
      27 * xScaling,
      78.6 * yScaling,
      23.8 * xScaling,
      72.8 * yScaling,
      19.1 * xScaling,
      67 * yScaling,
    );
    path.cubicTo(
      14.299999999999997 * xScaling,
      61.3 * yScaling,
      8 * xScaling,
      55.6 * yScaling,
      6.399999999999999 * xScaling,
      49.1 * yScaling,
    );
    path.cubicTo(
      4.799999999999997 * xScaling,
      42.5 * yScaling,
      7.799999999999997 * xScaling,
      35 * yScaling,
      12.100000000000001 * xScaling,
      28.3 * yScaling,
    );
    path.cubicTo(
      16.299999999999997 * xScaling,
      21.7 * yScaling,
      21.7 * xScaling,
      16 * yScaling,
      28.2 * xScaling,
      12.100000000000001 * yScaling,
    );
    path.cubicTo(
      34.7 * xScaling,
      8.200000000000003 * yScaling,
      42.4 * xScaling,
      6 * yScaling,
      48.7 * xScaling,
      8.200000000000003 * yScaling,
    );
    path.cubicTo(
      55.1 * xScaling,
      10.399999999999999 * yScaling,
      60.2 * xScaling,
      16.9 * yScaling,
      67 * xScaling,
      20.7 * yScaling,
    );
    path.cubicTo(
      67 * xScaling,
      20.7 * yScaling,
      67 * xScaling,
      20.7 * yScaling,
      67 * xScaling,
      20.7 * yScaling,
    );
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
