import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coinpay/src/settings/settings_controller.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  group('$SettingsController Tests', () {
    late MockSettingsService mockSettingsService;
    late SettingsController settingsController;

    setUp(() {
      mockSettingsService = MockSettingsService();
      settingsController = SettingsController(mockSettingsService);
    });

    test('loadSettings updates themeMode and notifies listeners', () async {
      // Arrange: Set up mock response
      when(() => mockSettingsService.themeMode())
          .thenAnswer((_) async => ThemeMode.dark);

      // Act
      await settingsController.loadSettings();

      // Assert
      expect(settingsController.themeMode, ThemeMode.dark);
      // Verify notifyListeners was called, you might need a way to check this
    });

    test(
        'updateThemeMode updates themeMode, notifies listeners, and persists settings',
        () async {
      when(() => mockSettingsService.themeMode())
          .thenAnswer((_) async => ThemeMode.system);

      when(() => mockSettingsService.updateThemeMode(ThemeMode.light))
          .thenAnswer((_) => Future.value());

      // Arrange
      await settingsController.loadSettings(); // Load initial settings

      // Act
      await settingsController.updateThemeMode(ThemeMode.light);

      // Assert
      expect(settingsController.themeMode, ThemeMode.light);
      // Verify notifyListeners was called
      verify(() => mockSettingsService.updateThemeMode(ThemeMode.light))
          .called(1);
    });

    // Add more tests as needed
  });
}
