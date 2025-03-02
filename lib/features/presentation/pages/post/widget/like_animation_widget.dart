import 'package:flutter/material.dart';

class LikeAnimationWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool isLikeAnimating;
  final VoidCallback? onLikeFinish;

  const LikeAnimationWidget({
    required this.child,
    required this.duration,
    required this.isLikeAnimating,
    this.onLikeFinish,
    super.key,
  });

  @override
  State<LikeAnimationWidget> createState() => _LikeAnimationWidgetState();
}

class _LikeAnimationWidgetState extends State<LikeAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2),
    );
    scale = Tween<double>(begin: 1, end: 1.2).animate(_controller);

    // If like animation should start immediately
    if (widget.isLikeAnimating) {
      beginLikeAnimation();
    }
  }

  @override
  void didUpdateWidget(covariant LikeAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isLikeAnimating && !oldWidget.isLikeAnimating) {
      beginLikeAnimation();
    }
  }

  void beginLikeAnimation() async {
    if (widget.isLikeAnimating) {
      await _controller.forward();
      await _controller.reverse();
      await Future.delayed(const Duration(milliseconds: 200));

      if (widget.onLikeFinish != null) {
        widget.onLikeFinish!();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: scale, child: widget.child);
  }
}
