import 'package:flutter/material.dart';

class MessageLayout extends StatelessWidget {
  final String message;
  final String imageUrl;

  const MessageLayout({super.key, required this.message, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 500,
              child: Image.asset(imageUrl),
            ),
            // SizedBox(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 150),
          ],
        ),
      ),
    );
  }
}
