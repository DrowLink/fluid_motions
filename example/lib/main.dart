import 'package:flutter/material.dart';

import 'views/basics_view.dart';
import 'views/interactions_view.dart';
import 'views/gestures_view.dart';

void main() {
  runApp(const FluidMotionsApp());
}

class FluidMotionsApp extends StatelessWidget {
  const FluidMotionsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluid Motions Demo',
      debugShowCheckedModeBanner: false,
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
  int _viewIndex = 0;

  final List<Widget> _views = [
    const BasicsView(),
    const InteractionsView(),
    const GesturesView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text('Fluid Motions', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _views[_viewIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _viewIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _viewIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets_outlined),
            activeIcon: Icon(Icons.widgets),
            label: 'Basics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.touch_app_outlined),
            activeIcon: Icon(Icons.touch_app),
            label: 'Interactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swipe_outlined),
            activeIcon: Icon(Icons.swipe),
            label: 'Gestures',
          ),
        ],
      ),
    );
  }
}
