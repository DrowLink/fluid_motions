import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluid_motions/fluid_motions.dart';

class BasicsView extends StatefulWidget {
  const BasicsView({super.key});

  @override
  State<BasicsView> createState() => _BasicsViewState();
}

class _BasicsViewState extends State<BasicsView> {
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Declarative State Widgets",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 10),
          const Text(
            "Tap the shape below to toggle its state.",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 40),
          
          GestureDetector(
            onTap: () {
              setState(() {
                _isActive = !_isActive;
              });
            },
            child: FluidTransform(
              isActive: _isActive,
              springConfig: FluidSpringConfig.bouncy(),
              activeScale: 1.2,
              inactiveScale: 1.0,
              activeRotation: pi / 4,
              inactiveRotation: 0.0,
              child: FluidContainer(
                isActive: _isActive,
                springConfig: FluidSpringConfig.bouncy(),
                inactiveDecoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                activeDecoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withValues(alpha: 0.5),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: const SizedBox(
                  width: 150,
                  height: 150,
                  child: Center(
                    child: Text(
                      'Tap Me!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
