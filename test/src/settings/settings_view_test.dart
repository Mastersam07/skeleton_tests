import 'package:coinpay/src/settings/settings_controller.dart';
import 'package:coinpay/src/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  testWidgets('$SettingsView Dropdown updates theme mode',
      (WidgetTester tester) async {
    // Arrange
    final mockService = MockSettingsService();
    when(() => mockService.themeMode())
        .thenAnswer((_) => Future.value(ThemeMode.system));
    when(() => mockService.updateThemeMode(ThemeMode.light))
        .thenAnswer((_) => Future.value());

    final mockController = SettingsController(mockService);

    await mockController.loadSettings();
    await tester.pumpWidget(MaterialApp(
      home: SettingsView(controller: mockController),
    ));

    await mockController.loadSettings();

    // Initial state check
    expect(mockController.themeMode.value,
        equals(ThemeMode.system)); // Assuming this is the default

    // Act: Open dropdown and select 'Light Theme'
    await tester.tap(find.byType(DropdownButton<ThemeMode>));
    await tester.pumpAndSettle(); // Wait for the dropdown to open

    await tester.tap(find.text('Light Theme').last);
    await tester.pumpAndSettle(); // Wait for the dropdown to close

    // Assert
    expect(mockController.themeMode.value, equals(ThemeMode.light));
  });
}
