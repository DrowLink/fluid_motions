import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import '../core/fluid_spring_config.dart';

/// A container that fluidly animates its decorative properties using spring
/// physics instead of static durations and curves.
class FluidContainer extends StatefulWidget {
  /// Determines which decoration should be displayed.
  /// When it changes, the physics animation is triggered.
  final bool isActive;

  /// The decoration to display when [isActive] is true.
  final BoxDecoration activeDecoration;

  /// The decoration to display when [isActive] is false.
  final BoxDecoration inactiveDecoration;

  /// Physical configuration of the spring.
  final FluidSpringConfig springConfig;

  /// Optional child widget.
  final Widget? child;

  const FluidContainer({
    super.key,
    required this.isActive,
    required this.activeDecoration,
    required this.inactiveDecoration,
    required this.springConfig,
    this.child,
  });

  @override
  State<FluidContainer> createState() => _FluidContainerState();
}

class _FluidContainerState extends State<FluidContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // We initialize the controller without default value bounds restrictions
    // (lowerBound 0 and upperBound 1.0), but we allow it to exceed the limits
    // because springs can generate overshoot (bounce above 1.0 or below 0.0).
    // Note: Although the bounds are 0 and 1.0 by default, animateWith allows 
    // it to temporarily exceed them.
    _controller = AnimationController(
      vsync: this,
      value: widget.isActive ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(covariant FluidContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the state changes, we trigger the spring animation towards the new value.
    if (oldWidget.isActive != widget.isActive) {
      _runAnimation();
    }
  }

  /// Executes the spring simulation to reach the desired value physically and fluidly.
  void _runAnimation() {
    // The target value. 1.0 represents the active state, 0.0 the inactive state.
    final double target = widget.isActive ? 1.0 : 0.0;

    // We get the current velocity of the controller to conserve momentum
    // if the animation is interrupted halfway. This is key for fluid animations.
    final double velocity = _controller.velocity;

    // We set up the spring simulation based on our configuration (mass, stiffness, damping).
    final SpringSimulation simulation = SpringSimulation(
      widget.springConfig.springDescription,
      _controller.value, // Starting position of the simulation
      target,            // Target position
      velocity,          // Initial velocity
    );

    // Animate using the physical simulation (ignores any previous duration and doesn't require one).
    _controller.animateWith(simulation);
  }

  @override
  void dispose() {
    // It's crucial to release the AnimationController resources
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Decoration.lerp handles smoothly transitioning between both BoxDecorations.
        // Since the controller can go above 1.0 or below 0.0 during bounces (overshoot),
        // lerp will correctly calculate intermediate or extrapolated values.
        final decoration = Decoration.lerp(
          widget.inactiveDecoration,
          widget.activeDecoration,
          _controller.value,
        ) as BoxDecoration?;

        return Container(
          decoration: decoration,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
