import 'package:flutter/material.dart';
import 'package:fluid_motions/fluid_motions.dart';

class GesturesView extends StatelessWidget {
  const GesturesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Fluid Gestures",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 10),
          const Text(
            "Drag the card and release it.\nWatch it bounce back with its release velocity.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 50),
          
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.drag_indicator,
                color: Colors.grey,
                size: 40,
              ),
            ),
          ).fluidDraggable(
            returnSpring: FluidSpringConfig.bouncy(),
          ),
        ],
      ),
    );
  }
}
