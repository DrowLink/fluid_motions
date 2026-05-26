import 'package:flutter_test/flutter_test.dart';
import 'package:fluid_motions/fluid_motions.dart';

void main() {
  group('FluidSpringConfig', () {
    test('bouncy factory sets correct default values', () {
      final config = FluidSpringConfig.bouncy();
      
      expect(config.mass, 1.0);
      expect(config.stiffness, 100.0);
      expect(config.damping, 10.0);
    });

    test('smooth factory sets correct default values', () {
      final config = FluidSpringConfig.smooth();
      
      expect(config.mass, 1.0);
      expect(config.stiffness, 100.0);
      expect(config.damping, 20.0);
    });

    test('springDescription generates valid Flutter SpringDescription', () {
      const config = FluidSpringConfig(
        mass: 2.0,
        stiffness: 50.0,
        damping: 5.0,
      );

      final description = config.springDescription;
      
      expect(description.mass, 2.0);
      expect(description.stiffness, 50.0);
      expect(description.damping, 5.0);
    });
  });
}
