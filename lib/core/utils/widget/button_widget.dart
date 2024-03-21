import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color color;
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;

  const MyButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.color = Colors.white70,
    this.width = double.infinity,
    this.height = 50.0,
    this.padding = const EdgeInsets.all(8.0), required ButtonStyle style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: padding,
        ),
      ),
    );
  }
}
