# Fluid Motions 🌊

[![Pub Version](https://img.shields.io/pub/v/fluid_motions.svg)](https://pub.dev/packages/fluid_motions)
[![Flutter Tests](https://img.shields.io/badge/Flutter-Tests-success.svg)](#)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

**👉 [Try the Interactive Web Demo!](https://DrowLink.github.io/fluid_motions/) 👈**

A declarative, physics-based animation engine for Flutter. 

Say goodbye to static `Duration`s and rigid `Curves`. **Fluid Motions** brings organic, spring-driven physics to your UI, inspired by Framer Motion. 

By leveraging continuous velocity and momentum preservation, animations feel natural, interruptible, and deeply satisfying—just like real-world objects.

---

## 🌟 Why Fluid Motions?

In traditional Flutter animations (`AnimatedContainer`, `Tween`, etc.), animations run for a hardcoded time (e.g., `300ms`). If a user interrupts the animation halfway through, the object abruptly stops and restarts, killing momentum.

**Fluid Motions** solves this by using `SpringSimulation` under the hood:
* **Physics, not durations**: Animations finish when they *naturally* settle, based on Mass, Stiffness, and Damping.
* **Momentum Preservation**: Interrupting an animation mid-flight redirects it smoothly, conserving its current velocity.
* **True Overshoot**: Elements can organically stretch past their bounds (bouncing) without complex curve math.

---

## 📦 Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  fluid_motions: ^0.0.1 # Check pub.dev for the latest version
```

## 🚀 Quick Start

Replace your traditional `AnimatedContainer` with `FluidContainer`. Notice you don't need to pass any durations!

```dart
import 'package:flutter/material.dart';
import 'package:fluid_motions/fluid_motions.dart';

class MyFluidWidget extends StatefulWidget {
  @override
  _MyFluidWidgetState createState() => _MyFluidWidgetState();
}

class _MyFluidWidgetState extends State<MyFluidWidget> {
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isActive = !_isActive),
      child: FluidContainer(
        isActive: _isActive,
        // 1. Define your physics (or use factories like .bouncy() / .smooth())
        springConfig: FluidSpringConfig.bouncy(),
        // 2. Define the inactive state
        inactiveDecoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(16),
        ),
        // 3. Define the active state
        activeDecoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(100),
        ),
        child: const SizedBox(
          width: 200, 
          height: 200, 
          child: Center(child: Text('Tap Me!', style: TextStyle(color: Colors.white))),
        ),
      ),
    );
  }
}
```

## ⚙️ Core Concepts

### `FluidSpringConfig`
The heart of the physics engine. It takes three parameters:
- **`mass`**: The weight of the object. Heavier objects are harder to move and stop.
- **`stiffness`**: The tension of the spring. Higher values make the animation snappier and faster.
- **`damping`**: The friction. Higher values reduce bounce, stopping the spring faster.

```dart
// Pre-built factories for convenience:
final bouncy = FluidSpringConfig.bouncy();
final smooth = FluidSpringConfig.smooth();

// Or create your own custom physics:
final custom = FluidSpringConfig(mass: 1.0, stiffness: 120.0, damping: 15.0);
```

### `FluidContainer`
A declarative widget that morphs its `BoxDecoration` between `inactiveDecoration` and `activeDecoration` smoothly using physics when `isActive` changes.

## 🤝 Contributing
Contributions are welcome! Feel free to open issues or submit Pull Requests to add more fluid widgets (like `FluidTransform`, `FluidFade`, etc.).

## 📄 License
This project is licensed under the MIT License - see the LICENSE file for details.
