import 'package:flutter/material.dart';

class AnimatedTile extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const AnimatedTile({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  State<AnimatedTile> createState() => _AnimatedTileState();
}

class _AnimatedTileState extends State<AnimatedTile> {
  double scale = 1;

  void _onTapDown(_) {
    setState(() => scale = 0.96);
  }

  void _onTapUp(_) {
    setState(() => scale = 1);
  }

  void _onTapCancel() {
    setState(() => scale = 1);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}