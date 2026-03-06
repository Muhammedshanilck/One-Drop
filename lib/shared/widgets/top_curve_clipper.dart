import 'package:flutter/material.dart';

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height - 10);

    path.quadraticBezierTo(
      size.width / 3,
      size.height,
      size.width,
      size.height - 70,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}