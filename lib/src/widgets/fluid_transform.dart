import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import '../core/fluid_spring_config.dart';

/// A widget that fluidly animates scale, translation, and rotation 
/// using spring physics instead of static durations and curves.
class FluidTransform extends StatefulWidget {
  /// Determines which transform state should be displayed.
  /// When it changes, the physics animation is triggered.
  final bool isActive;

  /// The scale to apply when [isActive] is true.
  final double activeScale;

  /// The scale to apply when [isActive] is false.
  final double inactiveScale;

  /// The translation offset to apply when [isActive] is true.
  final Offset activeOffset;

  /// The translation offset to apply when [isActive] is false.
  final Offset inactiveOffset;

  /// The rotation (in radians) to apply when [isActive] is true.
  final double activeRotation;

  /// The rotation (in radians) to apply when [isActive] is false.
  final double inactiveRotation;

  /// The alignment of the origin, relative to the size of the box.
  final AlignmentGeometry alignment;

  /// Physical configuration of the spring.
  final FluidSpringConfig springConfig;

  /// The widget below this widget in the tree.
  final Widget child;

  const FluidTransform({
    super.key,
    required this.isActive,
    this.activeScale = 1.0,
    this.inactiveScale = 1.0,
    this.activeOffset = Offset.zero,
    this.inactiveOffset = Offset.zero,
    this.activeRotation = 0.0,
    this.inactiveRotation = 0.0,
    this.alignment = Alignment.center,
    required this.springConfig,
    required this.child,
  });

  @override
  State<FluidTransform> createState() => _FluidTransformState();
}

class _FluidTransformState extends State<FluidTransform>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize controller. Allow overshoot.
    _controller = AnimationController(
      vsync: this,
      value: widget.isActive ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(covariant FluidTransform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      _runAnimation();
    }
  }

  void _runAnimation() {
    final double target = widget.isActive ? 1.0 : 0.0;
    final double velocity = _controller.velocity;

    final SpringSimulation simulation = SpringSimulation(
      widget.springConfig.springDescription,
      _controller.value,
      target,
      velocity,
    );

    _controller.animateWith(simulation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;

        // Lerp all transform properties manually based on the spring value 't'
        final currentScale = lerpDouble(widget.inactiveScale, widget.activeScale, t) ?? 1.0;
        final currentOffset = Offset.lerp(widget.inactiveOffset, widget.activeOffset, t) ?? Offset.zero;
        final currentRotation = lerpDouble(widget.inactiveRotation, widget.activeRotation, t) ?? 0.0;

        return Transform(
          alignment: widget.alignment,
          transform: Matrix4.identity()
            ..translate(currentOffset.dx, currentOffset.dy)
            ..scale(currentScale)
            ..rotateZ(currentRotation),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
