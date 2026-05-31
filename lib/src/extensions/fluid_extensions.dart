import 'package:flutter/widgets.dart';
import '../core/fluid_spring_config.dart';
import '../widgets/fluid_interactable.dart';
import '../widgets/fluid_draggable.dart';

/// Extension methods to easily wrap any Flutter [Widget] with fluid,
/// physics-based animations without deep nesting.
extension FluidExtensions on Widget {
  
  /// Wraps this widget in a [FluidInteractable], adding physical
  /// tap and hover responses automatically.
  Widget fluidInteractable({
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    double scaleOnHover = 1.02,
    double scaleOnTap = 0.95,
    double scaleIdle = 1.0,
    Offset offsetOnHover = Offset.zero,
    Offset offsetOnTap = Offset.zero,
    Offset offsetIdle = Offset.zero,
    FluidSpringConfig? springConfig,
  }) {
    return FluidInteractable(
      onTap: onTap,
      onLongPress: onLongPress,
      scaleOnHover: scaleOnHover,
      scaleOnTap: scaleOnTap,
      scaleIdle: scaleIdle,
      offsetOnHover: offsetOnHover,
      offsetOnTap: offsetOnTap,
      offsetIdle: offsetIdle,
      springConfig: springConfig,
      child: this,
    );
  }

  /// Wraps this widget in a [FluidDraggable], making it movable 
  /// across the screen with a physical spring return.
  Widget fluidDraggable({
    FluidSpringConfig? returnSpring,
    VoidCallback? onDragStarted,
    VoidCallback? onDragEnded,
  }) {
    return FluidDraggable(
      returnSpring: returnSpring ?? const FluidSpringConfig(mass: 1.0, stiffness: 200.0, damping: 20.0),
      child: this,
    );
  }
}
