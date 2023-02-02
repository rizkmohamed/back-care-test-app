import 'package:flutter/material.dart';

class GreyBorder extends StatelessWidget {
  const GreyBorder(
      {super.key,
      required this.child,
      this.height,
      this.width,
      this.padding,
      this.ismargin = true});
  final Widget? child;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final bool ismargin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: child,
      margin: ismargin ? EdgeInsets.all(10) : null,
      height: height,
      width: width,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.5,
        ),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    );
  }
}
