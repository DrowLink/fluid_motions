import 'package:flutter/physics.dart';

/// Configuration that defines the physics of our spring.
/// It uses mass, stiffness, and damping to calculate the motion.
class FluidSpringConfig {
  /// The mass of the object. A higher mass makes the object harder to move
  /// and harder to stop.
  final double mass;

  /// The stiffness of the spring. A higher value makes the spring faster and snappier.
  final double stiffness;

  /// The damping of the spring. A higher value makes the spring stop faster,
  /// reducing the bounces.
  final double damping;

  const FluidSpringConfig({
    required this.mass,
    required this.stiffness,
    required this.damping,
  });

  /// Default configuration for an effect with a lot of bounce.
  factory FluidSpringConfig.bouncy() {
    return const FluidSpringConfig(
      mass: 1.0,
      stiffness: 100.0,
      damping: 10.0, // Underdamped to allow for bounces
    );
  }

  /// Default configuration for a smooth motion without bounces.
  factory FluidSpringConfig.smooth() {
    return const FluidSpringConfig(
      mass: 1.0,
      stiffness: 100.0,
      damping: 20.0, // Critically damped
    );
  }

  /// Creates the Flutter spring simulation using these parameters.
  SpringDescription get springDescription {
    return SpringDescription(
      mass: mass,
      stiffness: stiffness,
      damping: damping,
    );
  }
}
