import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import '../core/fluid_spring_config.dart';
import 'fluid_interactable.dart';

/// A fluid and highly responsive switch with spring physics and jelly/stretch effects.
class FluidSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final FluidSpringConfig springConfig;
  
  /// Colors
  final Color activeTrackColor;
  final Color inactiveTrackColor;
  final Color activeThumbColor;
  final Color inactiveThumbColor;

  /// Sizing
  final double width;
  final double height;
  final double thumbPadding;

  const FluidSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.springConfig = const FluidSpringConfig(mass: 1.0, stiffness: 150.0, damping: 12.0),
    this.activeTrackColor = Colors.deepPurple,
    this.inactiveTrackColor = const Color(0xFFE0E0E0),
    this.activeThumbColor = Colors.white,
    this.inactiveThumbColor = Colors.white,
    this.width = 60.0,
    this.height = 32.0,
    this.thumbPadding = 4.0,
  });

  @override
  State<FluidSwitch> createState() => _FluidSwitchState();
}

class _FluidSwitchState extends State<FluidSwitch> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: widget.value ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(covariant FluidSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _runAnimation();
    }
  }

  void _runAnimation() {
    final double target = widget.value ? 1.0 : 0.0;
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
    return FluidInteractable(
      onTap: () => widget.onChanged(!widget.value),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value;
          final velocity = _controller.velocity;
          
          // Track color interpolation
          final trackColor = Color.lerp(
            widget.inactiveTrackColor,
            widget.activeTrackColor,
            t.clamp(0.0, 1.0), // Track color shouldn't overshoot visually
          );

          // Thumb color interpolation
          final thumbColor = Color.lerp(
            widget.inactiveThumbColor,
            widget.activeThumbColor,
            t.clamp(0.0, 1.0),
          );

          // Calculate dimensions
          final thumbSize = widget.height - (widget.thumbPadding * 2);
          final maxTravel = widget.width - widget.height; // Max x offset
          
          // Current offset based on t (can overshoot)
          final xOffset = t * maxTravel;

          // Jelly effect based on velocity
          // Stretch horizontally based on velocity magnitude, compress vertically
          final stretch = (velocity.abs() * 0.05).clamp(0.0, 0.4);
          final scaleX = 1.0 + stretch;
          final scaleY = 1.0 - (stretch * 0.5);

          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: trackColor,
              borderRadius: BorderRadius.circular(widget.height / 2),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: widget.thumbPadding,
                  left: widget.thumbPadding + xOffset,
                  child: Transform.scale(
                    scaleX: scaleX,
                    scaleY: scaleY,
                    alignment: velocity > 0 ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      width: thumbSize,
                      height: thumbSize,
                      decoration: BoxDecoration(
                        color: thumbColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
