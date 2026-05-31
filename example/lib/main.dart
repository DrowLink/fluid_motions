import 'dart:math';
import 'package:fluid_motions/fluid_motions.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluid Motions Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(title: const Text('Fluid Motions Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Existing Demo: FluidDraggable + FluidTransform + FluidContainer
            FluidDraggable(
              returnSpring: FluidSpringConfig.bouncy(),
              child: GestureDetector(
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
                          'Drag & Tap!',
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
            ),
            
            const SizedBox(height: 80),
            
            // 2. New Demo: FluidInteractable
            const Text(
              "FluidInteractable (Hover & Tap)",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            FluidInteractable(
              onTap: () {
                debugPrint("Premium button tapped!");
              },
              scaleOnHover: 1.05,
              scaleOnTap: 0.92,
              offsetOnHover: const Offset(0, -5), // Se eleva al hacer hover
              springConfig: FluidSpringConfig.bouncy(),
              child: Container(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
