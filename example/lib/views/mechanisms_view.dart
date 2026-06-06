import 'package:flutter/material.dart';

import 'basics_view.dart';
import 'interactions_view.dart';
import 'gestures_view.dart';

class MechanismsView extends StatefulWidget {
  const MechanismsView({super.key});

  @override
  State<MechanismsView> createState() => _MechanismsViewState();
}

class _MechanismsViewState extends State<MechanismsView> {
  int _viewIndex = 0;

  final List<Widget> _views = [
    const BasicsView(),
    const InteractionsView(),
    const GesturesView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
