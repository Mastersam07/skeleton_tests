import 'package:coinpay/src/sample_feature/sample_item.dart';
import 'package:coinpay/src/sample_feature/sample_item_details_view.dart';
import 'package:coinpay/src/sample_feature/sample_item_list_view.dart';
import 'package:coinpay/src/settings/settings_controller.dart';
import 'package:coinpay/src/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  testWidgets('$SampleItemListView builds correctly',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(const MaterialApp(home: SampleItemListView()));

    // Assert
    expect(find.byType(SampleItemListView), findsOneWidget);
  });

  testWidgets('$SampleItemListView Displays correct number of items',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 8000);
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: SampleItemListView(
          items: List.generate(20, (index) => SampleItem(index + 1)),
        ),
      ),
    );

    // Assert
    expect(find.byType(ListTile), findsNWidgets(20));

    addTearDown(() => tester.view.physicalSize = Size.zero);
  });

  testWidgets(
    '$SampleItemListView Tapping settings icon navigates to SettingsView',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 8000);
      // Mock or create a SettingsController
      final settingsService = MockSettingsService();
      when(() => settingsService.themeMode())
          .thenAnswer((_) => Future.value(ThemeMode.light));
      final settingsController = SettingsController(settingsService);
      await settingsController.loadSettings();

      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: SampleItemListView(
            items: List.generate(20, (index) => SampleItem(index + 1)),
          ),
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case SettingsView.routeName:
                return MaterialPageRoute(
                  builder: (context) =>
                      SettingsView(controller: settingsController),
                );
              default:
                return null;
            }
          },
        ),
      );

      // Act: Find and tap the settings icon
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Assert
      // Verify that navigation to SettingsView was triggered
      expect(find.byType(SettingsView), findsOneWidget);
      addTearDown(() => tester.view.physicalSize = Size.zero);
    },
  );

  testWidgets(
      '$SampleItemListView Tapping a ListTile navigates to the details page',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 8000);
    // Arrange
    await tester.pumpWidget(MaterialApp(
      home: SampleItemListView(
        items: List.generate(20, (index) => SampleItem(index + 1)),
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case SampleItemDetailsView.routeName:
            return MaterialPageRoute(
              builder: (context) => const SampleItemDetailsView(),
            );
          default:
            return null;
        }
      },
    ));

    // Act: Find and tap the first ListTile
    await tester.tap(find.byType(ListTile).first);
    await tester.pumpAndSettle();

    // Assert
    // Verify that navigation to SampleItemDetailsView was triggered
    expect(find.byType(SampleItemDetailsView), findsOneWidget);

    addTearDown(() => tester.view.physicalSize = Size.zero);
  });
}
