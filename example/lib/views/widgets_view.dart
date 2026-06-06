import 'package:flutter/material.dart';
import 'package:fluid_motions/fluid_motions.dart';

class WidgetsView extends StatefulWidget {
  const WidgetsView({super.key});

  @override
  State<WidgetsView> createState() => _WidgetsViewState();
}

class _WidgetsViewState extends State<WidgetsView> {
  bool _switchValue1 = false;
  bool _switchValue2 = true;
  bool _switchValue3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'FluidSwitch',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Un switch con físicas de resorte y efecto gelatina.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Ejemplo 1: Default
            _buildDemoCard(
              title: 'Default Bouncy Switch',
              child: FluidSwitch(
                value: _switchValue1,
                onChanged: (val) => setState(() => _switchValue1 = val),
              ),
            ),

            const SizedBox(height: 16),

            // Ejemplo 2: Smooth configuration
            _buildDemoCard(
              title: 'Smooth Switch (Lower Bounce)',
              child: FluidSwitch(
                value: _switchValue2,
                onChanged: (val) => setState(() => _switchValue2 = val),
                springConfig: FluidSpringConfig.smooth(),
                activeTrackColor: Colors.blue,
              ),
            ),

            const SizedBox(height: 16),

            // Ejemplo 3: Custom size and colors
            _buildDemoCard(
              title: 'Custom Size & Extreme Bounce',
              child: FluidSwitch(
                value: _switchValue3,
                onChanged: (val) => setState(() => _switchValue3 = val),
                springConfig: const FluidSpringConfig(
                  mass: 1.0,
                  stiffness: 300,
                  damping: 8.0,
                ),
                width: 80,
                height: 40,
                thumbPadding: 6,
                activeTrackColor: Colors.green,
                inactiveTrackColor: Colors.red.shade100,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'FluidActionButton',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Un FAB flotante que se transforma con físicas en un menú más grande.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Ejemplo FAB
            _buildFabDemoCard(),

            const SizedBox(
              height: 60,
            ), // Extra space for scrolling with open fab
          ],
        ),
      ),
    );
  }

  Widget _buildDemoCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildFabDemoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Morphing Speed Dial',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 20),
          Center(
            child: FluidActionButton(
              closedSize: const Size(64, 64),
              expandedSize: const Size(220, 64),
              closedChild: const Icon(Icons.add, color: Colors.white, size: 32),
              expandedChild: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.photo_camera,
                      color: Colors.deepPurple,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.videocam, color: Colors.deepPurple),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.mic, color: Colors.deepPurple),
                    onPressed: () {},
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.deepPurple.shade50),
                      onPressed: () {}, // Handled by FluidInteractable if we use IgnorePointer or if we expose a method, but left empty for now as requested.
                    ),
                  ),
                ],
              ),
              closedColor: Colors.deepPurple,
              expandedColor: Colors.deepPurple.shade50,
              expandedBorderRadius: BorderRadius.circular(32),
              springConfig: const FluidSpringConfig(
                mass: 1.0,
                stiffness: 180,
                damping: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
