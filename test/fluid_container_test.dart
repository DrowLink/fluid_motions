import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluid_motions/fluid_motions.dart';

void main() {
  group('FluidContainer', () {
    final activeDecoration = BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(100),
    );

    final inactiveDecoration = BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(0),
    );

    // Helper method to build our widget in a test environment
    Widget buildTestWidget({required bool isActive}) {
      return MaterialApp(
        home: Scaffold(
          body: FluidContainer(
            isActive: isActive,
            activeDecoration: activeDecoration,
            inactiveDecoration: inactiveDecoration,
            springConfig: FluidSpringConfig.smooth(), // Smooth settles faster for tests
            child: const SizedBox(width: 50, height: 50),
          ),
        ),
      );
    }

    // Helper method to find the specific Container rendered by FluidContainer
    Container getAnimatedContainer(WidgetTester tester) {
      return tester.widget<Container>(
        find.descendant(
          of: find.byType(FluidContainer),
          matching: find.byType(Container),
        ).first,
      );
    }

    testWidgets('renders inactive decoration initially when isActive is false', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(isActive: false));

      final container = getAnimatedContainer(tester);
      expect(container.decoration, inactiveDecoration);
    });

    testWidgets('renders active decoration initially when isActive is true', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(isActive: true));

      final container = getAnimatedContainer(tester);
      expect(container.decoration, activeDecoration);
    });

    testWidgets('animates decoration when isActive changes', (WidgetTester tester) async {
      // 1. Start with inactive state
      await tester.pumpWidget(buildTestWidget(isActive: false));
      
      Container container = getAnimatedContainer(tester);
      expect(container.decoration, inactiveDecoration);

      // 2. Trigger state change by rebuilding with isActive = true
      await tester.pumpWidget(buildTestWidget(isActive: true));

      // 3. Pump a small amount of time to start the animation
      await tester.pump(const Duration(milliseconds: 100));
      
      container = getAnimatedContainer(tester);
      // The decoration should be interpolating (neither fully active nor fully inactive)
      expect(container.decoration, isNot(inactiveDecoration));
      expect(container.decoration, isNot(activeDecoration));

      // 4. Wait for the spring simulation to completely settle
      await tester.pumpAndSettle();

      container = getAnimatedContainer(tester);
      // After settling, it should perfectly match the active decoration properties
      final actualDecoration = container.decoration as BoxDecoration;
      
      // Due to the nature of SpringSimulation and floating point lerping, 
      // the settled values might have microscopic differences (e.g. 99.99999 instead of 100.0).
      // Converting to string safely checks the rounded values match.
      expect(actualDecoration.borderRadius.toString(), activeDecoration.borderRadius.toString());
      
      // We check that the color channels are very close because lerping can
      // result in minor floating point precision differences
      expect(actualDecoration.color!.r, closeTo(activeDecoration.color!.r, 0.01));
      expect(actualDecoration.color!.g, closeTo(activeDecoration.color!.g, 0.01));
      expect(actualDecoration.color!.b, closeTo(activeDecoration.color!.b, 0.01));
    });
  });
}
