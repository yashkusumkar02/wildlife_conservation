import 'package:flutter/material.dart';

import 'curved_edges.dart';

class CurvedEdgesWidget extends StatelessWidget {
  const CurvedEdgesWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomCurvedEdges(),
      child: child,
    );
  }
}
