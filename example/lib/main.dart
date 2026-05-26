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
        // 1. FluidDraggable
        child: FluidDraggable(
          returnSpring: FluidSpringConfig.bouncy(),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isActive = !_isActive;
              });
            },
            // 2. FluidTransform
            child: FluidTransform(
              isActive: _isActive,
              springConfig: FluidSpringConfig.bouncy(),
              activeScale: 1.2,
              inactiveScale: 1.0,
              activeRotation: pi / 4,
              inactiveRotation: 0.0,
              // 3. FluidContainer
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
      ),
    );
  }
}
