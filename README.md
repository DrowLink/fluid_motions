# Fluid Motions

[![Pub Version](https://img.shields.io/pub/v/fluid_motions.svg)](https://pub.dev/packages/fluid_motions)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

**[Interactive Web Demo](https://DrowLink.github.io/fluid_motions/)**

A declarative, physics-based animation engine for Flutter, inspired by Framer Motion. 

Fluid Motions replaces rigid, duration-based tweens with continuous spring physics. It allows developers to create organic, interruptible animations that conserve momentum and feel deeply satisfying to the touch.

---

## Why Fluid Motions?

Traditional Flutter animations run for a hardcoded time (e.g., `300ms`). If a user interrupts the animation halfway through, the object abruptly stops and restarts, killing momentum.

**Fluid Motions** solves this by using `SpringSimulation` under the hood:
* **Physics, not durations**: Animations finish when they naturally settle, based on Mass, Stiffness, and Damping.
* **Momentum Preservation**: Interrupting an animation mid-flight redirects it smoothly, conserving its current velocity.
* **Declarative API**: Wrap any widget with our extensions to add complex interactions without managing state.

---

## Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  fluid_motions: ^0.0.4
```

---

## Core Features & Usage

### 1. The Extension API (Recommended)
The easiest way to add physical interactions to any Flutter widget. By importing the package, your widgets gain access to fluid extension methods.

**`fluidInteractable`**
Automatically tracks Tap and Hover gestures, animating scale and position using continuous spring physics.

```dart
import 'package:fluid_motions/fluid_motions.dart';

Container(
  padding: const EdgeInsets.all(16),
  color: Colors.deepPurple,
  child: const Text("Interact With Me", style: TextStyle(color: Colors.white)),
).fluidInteractable(
  onTap: () => print("Tapped!"),
  scaleOnHover: 1.05,
  scaleOnTap: 0.90,
  offsetOnHover: const Offset(0, -5), // Elevates smoothly on mouse hover
  springConfig: FluidSpringConfig.bouncy(),
);
```

**`fluidDraggable`**
Makes any widget freely draggable across the screen. When released, it uses a physical spring simulation to return to its origin, conserving the drag velocity.

```dart
Card(child: Text("Drag me around!")).fluidDraggable();
```

---

### 2. Declarative State Widgets
If you prefer explicit state management over extensions, Fluid Motions provides powerful container widgets.

**`FluidContainer`**
A declarative widget that morphs its `BoxDecoration` smoothly using physics when `isActive` changes.

```dart
FluidContainer(
  isActive: _isActive,
  springConfig: FluidSpringConfig.smooth(),
  inactiveDecoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(16),
  ),
  activeDecoration: BoxDecoration(
    color: Colors.red,
    borderRadius: BorderRadius.circular(100),
  ),
  child: const SizedBox(width: 200, height: 200),
)
```

**`FluidTransform`**
Animates scale, rotation, and translation based on a binary active/inactive state.

---

### 3. Physics Configuration

The heart of the physics engine is the `FluidSpringConfig`. It dictates how the animation feels:
- **`mass`**: The weight of the object. Heavier objects are harder to move and stop.
- **`stiffness`**: The tension of the spring. Higher values make the animation snappier and faster.
- **`damping`**: The friction. Higher values reduce bounce.

```dart
// Built-in factories for quick prototyping:
final bouncy = FluidSpringConfig.bouncy();
final smooth = FluidSpringConfig.smooth();

// Custom configuration:
final custom = FluidSpringConfig(mass: 1.0, stiffness: 120.0, damping: 15.0);
```

---

## Contributing
Contributions are welcome! Feel free to open issues or submit Pull Requests.
### Email: pauloriveiro01@gmail.com

## License
This project is licensed under the MIT License - see the LICENSE file for details.
