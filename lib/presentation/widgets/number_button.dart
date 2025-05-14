import 'package:flutter/material.dart';

class NumberButton extends StatelessWidget {
  final VoidCallback onPressed;

  const NumberButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Generate Number', style: TextStyle(fontSize: 18)),
    );
  }
}
