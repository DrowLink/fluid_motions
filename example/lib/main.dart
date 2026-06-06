import 'package:flutter/material.dart';

import 'views/mechanisms_view.dart';
import 'views/widgets_view.dart';

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

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F2F5),
        appBar: AppBar(
          title: const Text('Fluid Motions', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          bottom: const TabBar(
            labelColor: Colors.deepPurple,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.deepPurple,
            tabs: [
              Tab(text: 'Mechanisms'),
              Tab(text: 'Widgets'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MechanismsView(),
            WidgetsView(),
          ],
        ),
      ),
    );
  }
}
