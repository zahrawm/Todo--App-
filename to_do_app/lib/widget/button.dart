import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  
  final Color color;
  final VoidCallback? onPressed;

  const MyButton({
    super.key,
  
    required this.text,
    required this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: color,
      textColor: Colors.white,
      minWidth: 380,
      height: 50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Text(text)]),
    );
  }
}
