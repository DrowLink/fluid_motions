import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import '../core/fluid_spring_config.dart';
import 'fluid_interactable.dart';

/// A Floating Action Button that morphs smoothly into a menu or larger element
/// using spring physics.
class FluidActionButton extends StatefulWidget {
  /// The widget to show when the button is closed (usually an Icon).
  final Widget closedChild;

  /// The widget to show when the button is expanded.
  final Widget expandedChild;

  /// The size of the button when closed. Defaults to standard FAB size (56x56).
  final Size closedSize;

  /// The size of the button when expanded.
  final Size expandedSize;

  /// The border radius when closed. Defaults to circular.
  final BorderRadius? closedBorderRadius;

  /// The border radius when expanded. Defaults to slightly rounded.
  final BorderRadius? expandedBorderRadius;

  /// Background color when closed.
  final Color closedColor;

  /// Background color when expanded.
  final Color expandedColor;

  /// Spring physics configuration.
  final FluidSpringConfig springConfig;

  /// Optional callback when toggled.
  final ValueChanged<bool>? onToggle;

  const FluidActionButton({
    super.key,
    required this.closedChild,
    required this.expandedChild,
    required this.expandedSize,
    this.closedSize = const Size(56.0, 56.0),
    this.closedBorderRadius,
    this.expandedBorderRadius,
    this.closedColor = Colors.deepPurple,
    this.expandedColor = Colors.white,
    this.springConfig = const FluidSpringConfig(mass: 1.0, stiffness: 120.0, damping: 14.0),
    this.onToggle,
  });

  @override
  State<FluidActionButton> createState() => _FluidActionButtonState();
}

class _FluidActionButtonState extends State<FluidActionButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: 0.0,
    );
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
    });
    
    if (widget.onToggle != null) {
      widget.onToggle!(_isOpen);
    }

    _runAnimation();
  }

  void _runAnimation() {
    final double target = _isOpen ? 1.0 : 0.0;
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
    // Defaults for border radii
    final defaultClosedRadius = BorderRadius.circular(widget.closedSize.shortestSide / 2);
    final defaultExpandedRadius = BorderRadius.circular(16.0);

    return FluidInteractable(
      onTap: _toggle,
      // We reduce the scale effect slightly because the morphing itself is dramatic
      springConfig: const FluidSpringConfig(mass: 1.0, stiffness: 200, damping: 20),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value;
          
          // Interpolate properties
          // Using clamp for visual boundaries (size and color) to prevent
          // negative dimensions or weird color blending, but allowing position overshoot
          final clampedT = t.clamp(0.0, 1.0);
          
          final width = Tween<double>(begin: widget.closedSize.width, end: widget.expandedSize.width).transform(t);
          final height = Tween<double>(begin: widget.closedSize.height, end: widget.expandedSize.height).transform(t);
          
          final color = Color.lerp(widget.closedColor, widget.expandedColor, clampedT);
          
          final borderRadius = BorderRadius.lerp(
            widget.closedBorderRadius ?? defaultClosedRadius,
            widget.expandedBorderRadius ?? defaultExpandedRadius,
            clampedT,
          );

          // We fade out the closed child faster (0.0 to 0.4)
          final closedOpacity = (1.0 - (clampedT * 2.5)).clamp(0.0, 1.0);
          
          // We fade in the expanded child slower (0.5 to 1.0)
          final expandedOpacity = ((clampedT - 0.5) * 2.0).clamp(0.0, 1.0);

          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: color,
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1 + (clampedT * 0.1)),
                  blurRadius: 8 + (clampedT * 8),
                  offset: Offset(0, 4 + (clampedT * 4)),
                ),
              ],
            ),
            // Use Clip.hardEdge so expanded content doesn't overflow when shrinking
            clipBehavior: Clip.hardEdge,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Closed Child
                if (closedOpacity > 0)
                  Opacity(
                    opacity: closedOpacity,
                    // Small scale down effect when hiding
                    child: Transform.scale(
                      scale: 0.8 + (closedOpacity * 0.2),
                      child: widget.closedChild,
                    ),
                  ),
                  
                // Expanded Child
                if (expandedOpacity > 0)
                  Opacity(
                    opacity: expandedOpacity,
                    // Small slide up effect when appearing
                    child: Transform.translate(
                      offset: Offset(0, 10 * (1.0 - expandedOpacity)),
                      child: widget.expandedChild,
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
