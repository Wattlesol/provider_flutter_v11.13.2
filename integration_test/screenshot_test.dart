import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:handyman_provider_flutter/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Screenshots', () {
    testWidgets('Take screenshots of all main screens',
        (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Screenshot 1: Splash Screen
      await takeScreenshot(binding, 'splash_screen');

      // Wait for splash to complete and navigate to next screen
      await tester.pumpAndSettle(Duration(seconds: 5));

      // Screenshot 2: Sign In Screen (if not logged in)
      await takeScreenshot(binding, 'sign_in_screen');

      // Try to find login form elements
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;

      // Look for login button
      Finder loginButton = find.text('Sign In');
      if (loginButton.evaluate().isEmpty) {
        loginButton = find.text('Login');
      }
      if (loginButton.evaluate().isEmpty) {
        loginButton = find.byType(ElevatedButton);
      }

      if (emailField.evaluate().isNotEmpty &&
          passwordField.evaluate().isNotEmpty) {
        // Fill in test credentials (you'll need to replace with valid test credentials)
        await tester.enterText(emailField, 'demo@handyman.com');
        await tester.enterText(passwordField, '12345678');
        await tester.pumpAndSettle();

        // Screenshot 3: Login form filled
        await takeScreenshot(binding, 'login_form_filled');

        // Tap login button if it exists
        if (loginButton.evaluate().isNotEmpty) {
          await tester.tap(loginButton);
          await tester.pumpAndSettle(Duration(seconds: 3));
        }
      }

      // Screenshot 4: Dashboard/Home Screen
      await takeScreenshot(binding, 'dashboard_home');

      // Navigate through bottom navigation tabs
      await navigateBottomTabs(tester, binding);

      // Test drawer/menu if available
      await testDrawerNavigation(tester, binding);
    });
  });
}

Future<void> takeScreenshot(
    IntegrationTestWidgetsFlutterBinding binding, String name) async {
  await binding.convertFlutterSurfaceToImage();
  await binding.takeScreenshot(name);
  print('Screenshot taken: $name');
}

Future<void> navigateBottomTabs(
    WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding) async {
  // Look for NavigationBar or BottomNavigationBar
  final navigationBar = find.byType(NavigationBar);
  final bottomNavBar = find.byType(BottomNavigationBar);

  if (navigationBar.evaluate().isNotEmpty) {
    // Modern NavigationBar
    final destinations = find.descendant(
      of: navigationBar,
      matching: find.byType(NavigationDestination),
    );

    for (int i = 0; i < destinations.evaluate().length; i++) {
      await tester.tap(destinations.at(i));
      await tester.pumpAndSettle();
      await takeScreenshot(binding, 'navigation_tab_$i');
    }
  } else if (bottomNavBar.evaluate().isNotEmpty) {
    // Legacy BottomNavigationBar
    final items = find.descendant(
      of: bottomNavBar,
      matching: find.byType(BottomNavigationBarItem),
    );

    for (int i = 0; i < items.evaluate().length; i++) {
      await tester.tap(items.at(i));
      await tester.pumpAndSettle();
      await takeScreenshot(binding, 'bottom_nav_tab_$i');
    }
  }
}

Future<void> testDrawerNavigation(
    WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding) async {
  // Look for drawer button
  final drawerButton = find.byIcon(Icons.menu);

  if (drawerButton.evaluate().isNotEmpty) {
    await tester.tap(drawerButton);
    await tester.pumpAndSettle();
    await takeScreenshot(binding, 'drawer_opened');

    // Close drawer
    await tester.tap(find.byType(Scaffold));
    await tester.pumpAndSettle();
  }
}
