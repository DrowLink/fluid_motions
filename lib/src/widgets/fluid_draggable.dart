import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

import '../core/fluid_spring_config.dart';

/// A widget that allows its child to be freely dragged across the screen in 2D space.
/// 
/// When the drag gesture ends, the widget uses a physical spring simulation to
/// return the child to its original position ([Offset.zero]), conserving the 
/// inertia and velocity of the drag for a natural and fluid motion.
class FluidDraggable extends StatefulWidget {
  /// The widget below this widget in the tree.
  final Widget child;

  /// The physical configuration for the spring that returns the child
  /// to its original position after the drag ends.
  final FluidSpringConfig returnSpring;

  /// Creates a [FluidDraggable].
  ///
  /// The [child] and [returnSpring] arguments must not be null.
  const FluidDraggable({
    super.key,
    required this.child,
    required this.returnSpring,
  });

  @override
  State<FluidDraggable> createState() => _FluidDraggableState();
}

class _FluidDraggableState extends State<FluidDraggable> with SingleTickerProviderStateMixin {
  /// The controller that drives the spring simulation.
  /// We use an unbounded controller because physical simulations (like bouncy springs
  /// or time-based simulations) can easily overshoot the standard 0.0 to 1.0 range.
  late final AnimationController _controller;

  /// The current offset of the child relative to its original position.
  /// Using a [ValueNotifier] is more efficient than calling [setState] on every pixel change,
  /// as it only rebuilds the [Transform] widget listening to it.
  final ValueNotifier<Offset> _dragOffset = ValueNotifier<Offset>(Offset.zero);

  SpringSimulation? _springX;
  SpringSimulation? _springY;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this);
    _controller.addListener(_updateOffsetFromSimulation);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateOffsetFromSimulation);
    _controller.dispose();
    _dragOffset.dispose();
    super.dispose();
  }

  /// Updates the `_dragOffset` based on the current time of the simulation.
  void _updateOffsetFromSimulation() {
    if (_springX == null || _springY == null) return;
    
    // The controller's value represents the elapsed time of the simulation.
    final double time = _controller.value;
    
    _dragOffset.value = Offset(
      _springX!.x(time),
      _springY!.x(time),
    );
  }

  void _onPanStart(DragStartDetails details) {
    // If the user grabs the widget while it's still bouncing back,
    // stop the animation immediately.
    if (_controller.isAnimating) {
      _controller.stop();
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    // Update the offset directly as the user drags.
    _dragOffset.value += details.delta;
  }

  void _onPanEnd(DragEndDetails details) {
    // Extract the release velocity in both axes.
    final Offset pixelsPerSecond = details.velocity.pixelsPerSecond;
    _runSpringSimulation(pixelsPerSecond);
  }

  /// Generates the spring simulations for X and Y axes and starts the animation.
  void _runSpringSimulation(Offset pixelsPerSecond) {
    final SpringDescription springDesc = widget.returnSpring.springDescription;
    final Offset startOffset = _dragOffset.value;

    // Create independent spring simulations for X and Y, feeding them the initial velocity.
    _springX = SpringSimulation(
      springDesc,
      startOffset.dx,
      0.0, // Target position is 0.0 (original position)
      pixelsPerSecond.dx,
    );

    _springY = SpringSimulation(
      springDesc,
      startOffset.dy,
      0.0, // Target position is 0.0 (original position)
      pixelsPerSecond.dy,
    );

    // Drive the animation controller using a custom 2D time simulation.
    _controller.animateWith(_SpringTimeSimulation(_springX!, _springY!));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Offset>(
      valueListenable: _dragOffset,
      builder: (context, offset, child) {
        return Transform.translate(
          offset: offset,
          child: child,
        );
      },
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        // Ensures we can grab the widget even if it has transparent areas
        behavior: HitTestBehavior.deferToChild,
        child: widget.child,
      ),
    );
  }
}

/// A custom [Simulation] that drives the time for two independent [SpringSimulation]s.
/// 
/// Instead of returning a physical position, this simulation simply returns the elapsed time.
/// It considers itself "done" only when both the X and Y spring simulations are at rest.
class _SpringTimeSimulation extends Simulation {
  final SpringSimulation springX;
  final SpringSimulation springY;

  _SpringTimeSimulation(this.springX, this.springY);

  @override
  double x(double time) => time; // The value of the controller will be the time.

  @override
  double dx(double time) => 1.0; // Time moves at a constant rate of 1.0.

  @override
  bool isDone(double time) => springX.isDone(time) && springY.isDone(time);
}
