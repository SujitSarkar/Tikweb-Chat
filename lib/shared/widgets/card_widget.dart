import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  const CardWidget(
      {super.key,
      required this.child,
      this.contentPadding,
      this.height,
      this.width,
      this.borderRadius = 5,
      this.gradient});
  final Widget child;
  final EdgeInsetsGeometry? contentPadding;
  final double? height;
  final double? width;
  final double borderRadius;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: contentPadding,
      decoration: BoxDecoration(
          color: gradient == null ? Colors.white : null,
          gradient: gradient,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 8,
                offset: const Offset(1, 4))
          ]),
      child: child,
    );
  }
}
