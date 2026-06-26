import 'package:flutter/material.dart';

class SolidBackground extends StatelessWidget {
  final Widget child;
  const SolidBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1B1B1B), Color(0xFF121212)],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 1,
            child: Container(color: Colors.white.withValues(alpha: 0.06)),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}
