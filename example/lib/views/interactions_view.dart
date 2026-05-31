import 'package:flutter/material.dart';
import 'package:fluid_motions/fluid_motions.dart';

class InteractionsView extends StatelessWidget {
  const InteractionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "The Extension API",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 10),
          const Text(
            "Hover and Tap the button below.\nNo manual state management required.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 50),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Text(
              "Interact With Me",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ).fluidInteractable(
            onTap: () {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Button tapped! Momentum preserved.')),
              );
            },
            scaleOnHover: 1.05,
            scaleOnTap: 0.92,
            offsetOnHover: const Offset(0, -5), // Elevates on hover
            springConfig: FluidSpringConfig.bouncy(),
          ),
        ],
      ),
    );
  }
}
