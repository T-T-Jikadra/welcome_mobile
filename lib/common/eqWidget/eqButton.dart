import 'package:flutter/material.dart';

class EqButton extends StatefulWidget {
  EqButton({
    super.key,
    Color? color,
    required this.text,
    required this.onPressed,
  })  : color = color ?? Colors.indigo.shade400;

  final String text;
  final VoidCallback onPressed;
  final Color color;

  @override
  State<EqButton> createState() => EqButtonState();
}

class EqButtonState extends State<EqButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.color,
          shape: const BeveledRectangleBorder(),
        ),
        onPressed: widget.onPressed,
        child: Text(
          widget.text,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

// To auto trigger the onPressed ..
  void trigger() {
    widget.onPressed();
  }
}
