/// A Flutter package that provides smooth, physics-based animations for UI elements.
/// It uses SpringSimulation to create natural, organic movements that mimic
/// real-world physics, avoiding the stiffness of traditional tween animations.
///
/// Key Features:
/// - **Fluid Animations**: Uses physics-based spring simulation for natural motion.
/// - **Overshoot Support**: Allows values to temporarily exceed their bounds (e.g., > 1.0 or < 0.0) for realistic "bounce".
/// - **Momentum Preservation**: Maintains velocity when animations are interrupted and restarted.
/// - **Customizable Physics**: Tweak mass, stiffness, and damping for different animation feels.
///
/// Widgets Included:
/// - `FluidContainer`: Animates `BoxDecoration` properties between two states.
/// - `FluidTransform`: Animates scale, rotation, and translation with physics.
/// - `FluidSpringConfig`: A class to configure the physics parameters (`mass`, `stiffness`, `damping`).
///
/// Usage Example:
/// ```dart
/// FluidContainer(
///   isActive: _isActive,
///   springConfig: FluidSpringConfig.bouncy(),
///   inactiveDecoration: BoxDecoration(color: Colors.blue),
///   activeDecoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(100)),
///   child: const SizedBox(width: 100, height: 100),
/// )
/// ```
library;

export 'src/widgets/fluid_container.dart';
export 'src/widgets/fluid_draggable.dart';
export 'src/widgets/fluid_interactable.dart';
export 'src/core/fluid_spring_config.dart';
export 'src/widgets/fluid_transform.dart';
export 'src/widgets/fluid_switch.dart';
export 'src/widgets/fluid_action_button.dart';
export 'src/extensions/fluid_extensions.dart';
