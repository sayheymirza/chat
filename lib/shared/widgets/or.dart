import 'package:flutter/material.dart';

class OrWidget extends StatelessWidget {
  final String text;

  const OrWidget({super.key, this.text = "یا"});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Colors.black38,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.black38,
          ),
        ),
      ],
    );
  }
}
