import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';
import '../core/fluid_spring_config.dart';

/// A wrapper widget that provides out-of-the-box physical animations for 
/// common user interactions like Tap and Hover.
/// 
/// Instead of managing states manually, [FluidInteractable] handles the logic
/// and applies continuous spring physics to scale and translation.
class FluidInteractable extends StatefulWidget {
  /// Called when the user taps the widget.
  final VoidCallback? onTap;

  /// Called when the user long-presses the widget.
  final VoidCallback? onLongPress;

  /// The scale of the widget when hovered (Mouse only).
  final double scaleOnHover;

  /// The scale of the widget when pressed.
  final double scaleOnTap;

  /// The default scale of the widget.
  final double scaleIdle;

  /// The translation offset when hovered (Mouse only).
  final Offset offsetOnHover;

  /// The translation offset when pressed.
  final Offset offsetOnTap;

  /// The default translation offset.
  final Offset offsetIdle;

  /// The physical properties of the spring.
  final FluidSpringConfig springConfig;

  /// The widget below this widget in the tree.
  final Widget child;

  const FluidInteractable({
    super.key,
    this.onTap,
    this.onLongPress,
    this.scaleOnHover = 1.02,
    this.scaleOnTap = 0.95,
    this.scaleIdle = 1.0,
    this.offsetOnHover = Offset.zero,
    this.offsetOnTap = Offset.zero,
    this.offsetIdle = Offset.zero,
    FluidSpringConfig? springConfig,
    required this.child,
  }) : springConfig = springConfig ?? const FluidSpringConfig(mass: 1.0, stiffness: 200.0, damping: 20.0);

  @override
  State<FluidInteractable> createState() => _FluidInteractableState();
}

class _FluidInteractableState extends State<FluidInteractable> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _dxController;
  late AnimationController _dyController;

  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    // Unbounded controllers allow the value to overshoot past 1.0 or 0.0 naturally.
    _scaleController = AnimationController.unbounded(vsync: this, value: widget.scaleIdle);
    _dxController = AnimationController.unbounded(vsync: this, value: widget.offsetIdle.dx);
    _dyController = AnimationController.unbounded(vsync: this, value: widget.offsetIdle.dy);
  }

  @override
  void didUpdateWidget(covariant FluidInteractable oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If widget properties changed while idle, animate to the new idle state.
    if (!_isHovered && !_isPressed) {
      if (oldWidget.scaleIdle != widget.scaleIdle || oldWidget.offsetIdle != widget.offsetIdle) {
         _runAnimations();
      }
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _dxController.dispose();
    _dyController.dispose();
    super.dispose();
  }

  /// Calculates the target values based on the current interaction state
  /// and runs the spring simulation towards those targets.
  void _runAnimations() {
    double targetScale = widget.scaleIdle;
    Offset targetOffset = widget.offsetIdle;

    if (_isPressed) {
      targetScale = widget.scaleOnTap;
      targetOffset = widget.offsetOnTap;
    } else if (_isHovered) {
      targetScale = widget.scaleOnHover;
      targetOffset = widget.offsetOnHover;
    }

    _animateController(_scaleController, targetScale);
    _animateController(_dxController, targetOffset.dx);
    _animateController(_dyController, targetOffset.dy);
  }

  /// Drives an animation controller with a SpringSimulation towards a target value.
  void _animateController(AnimationController controller, double target) {
    // If we are already at the target with no velocity, don't trigger a new simulation.
    // This prevents unnecessary rebuilds.
    if ((controller.value - target).abs() < 0.001 && controller.velocity.abs() < 0.001) {
      return;
    }
    
    final simulation = SpringSimulation(
      widget.springConfig.springDescription,
      controller.value,
      target,
      controller.velocity,
    );
    
    controller.animateWith(simulation);
  }

  void _handleHover(bool isHovered) {
    if (_isHovered != isHovered) {
      setState(() => _isHovered = isHovered);
      _runAnimations();
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (!_isPressed) {
      setState(() => _isPressed = true);
      _runAnimations();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _runAnimations();
    }
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _runAnimations();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the hit test behavior. Opaque allows the whole region to be clickable,
    // even if the child doesn't fill it entirely.
    final behavior = widget.onTap != null || widget.onLongPress != null 
        ? HitTestBehavior.opaque 
        : HitTestBehavior.deferToChild;

    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        behavior: behavior,
        onTapDown: widget.onTap != null ? _handleTapDown : null,
        onTapUp: widget.onTap != null ? _handleTapUp : null,
        onTapCancel: widget.onTap != null ? _handleTapCancel : null,
        onLongPress: widget.onLongPress,
        child: AnimatedBuilder(
          animation: Listenable.merge([_scaleController, _dxController, _dyController]),
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..multiply(Matrix4.translationValues(_dxController.value, _dyController.value, 0.0))
                ..multiply(Matrix4.diagonal3Values(_scaleController.value, _scaleController.value, 1.0)),
              child: child,
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}
