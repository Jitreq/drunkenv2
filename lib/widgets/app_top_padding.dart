import 'package:flutter/material.dart';

class AppTopPadding extends StatelessWidget {
  const AppTopPadding({super.key, required this.child});

  static const EdgeInsets padding = EdgeInsets.only(top: 28);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: child,
    );
  }
}
