import 'package:flutter/material.dart';

class ListTextButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const ListTextButton(this.text, {super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        backgroundColor: Colors.blue.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.5,
          color: Colors.blueAccent,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
