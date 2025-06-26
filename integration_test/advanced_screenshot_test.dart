import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:handyman_provider_flutter/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Comprehensive App Screenshots', () {
    testWidgets('Provider Flow Screenshots', (WidgetTester tester) async {
      await runScreenshotFlow(tester, binding, 'provider');
    });

    testWidgets('Handyman Flow Screenshots', (WidgetTester tester) async {
      await runScreenshotFlow(tester, binding, 'handyman');
    });
  });
}

Future<void> runScreenshotFlow(WidgetTester tester,
    IntegrationTestWidgetsFlutterBinding binding, String userType) async {
  print('Starting $userType flow screenshots...');

  // Start the app
  app.main();
  await tester.pumpAndSettle();

  // 1. Splash Screen
  await takeScreenshot(binding, '${userType}_01_splash');
  await tester.pumpAndSettle(Duration(seconds: 3));

  // 2. Authentication Flow
  await captureAuthFlow(tester, binding, userType);

  // 3. Dashboard Flow
  await captureDashboardFlow(tester, binding, userType);

  // 4. Navigation Flow
  await captureNavigationFlow(tester, binding, userType);

  // 5. Profile Flow
  await captureProfileFlow(tester, binding, userType);

  // 6. Settings Flow
  await captureSettingsFlow(tester, binding, userType);
}

Future<void> captureAuthFlow(WidgetTester tester,
    IntegrationTestWidgetsFlutterBinding binding, String userType) async {
  print('Capturing auth flow for $userType...');

  // Sign In Screen
  await takeScreenshot(binding, '${userType}_02_signin');

  // Look for common UI elements
  final textFields = find.byType(TextFormField);

  if (textFields.evaluate().length >= 2) {
    // Fill email field based on user type
    String email =
        userType == 'handyman' ? 'demo@handyman.com' : 'demo@provider.com';
    await tester.enterText(textFields.first, email);
    await tester.pumpAndSettle();

    // Fill password field
    await tester.enterText(textFields.at(1), '12345678');
    await tester.pumpAndSettle();

    await takeScreenshot(binding, '${userType}_03_signin_filled');
  }

  // Look for sign up link/button
  Finder signUpFinder = find.text('Sign Up');
  if (signUpFinder.evaluate().isEmpty) {
    signUpFinder = find.text('Register');
  }
  if (signUpFinder.evaluate().isNotEmpty) {
    await tester.tap(signUpFinder);
    await tester.pumpAndSettle();
    await takeScreenshot(binding, '${userType}_04_signup');

    // Go back to sign in
    final backButton = find.byIcon(Icons.arrow_back);
    if (backButton.evaluate().isNotEmpty) {
      await tester.tap(backButton);
      await tester.pumpAndSettle();
    }
  }

  // Look for forgot password
  Finder forgotPasswordFinder = find.text('Forgot Password?');
  if (forgotPasswordFinder.evaluate().isEmpty) {
    forgotPasswordFinder = find.text('Forgot Password');
  }
  if (forgotPasswordFinder.evaluate().isNotEmpty) {
    await tester.tap(forgotPasswordFinder);
    await tester.pumpAndSettle();
    await takeScreenshot(binding, '${userType}_05_forgot_password');

    // Go back
    final backButton = find.byIcon(Icons.arrow_back);
    if (backButton.evaluate().isNotEmpty) {
      await tester.tap(backButton);
      await tester.pumpAndSettle();
    }
  }
}

Future<void> captureDashboardFlow(WidgetTester tester,
    IntegrationTestWidgetsFlutterBinding binding, String userType) async {
  print('Capturing dashboard flow for $userType...');

  // Main dashboard
  await takeScreenshot(binding, '${userType}_06_dashboard');

  // Look for cards or list items to tap
  final cards = find.byType(Card);
  if (cards.evaluate().isNotEmpty) {
    // Take screenshot of first card interaction
    await tester.tap(cards.first);
    await tester.pumpAndSettle();
    await takeScreenshot(binding, '${userType}_07_card_detail');

    // Go back
    final backButton = find.byIcon(Icons.arrow_back);
    if (backButton.evaluate().isNotEmpty) {
      await tester.tap(backButton);
      await tester.pumpAndSettle();
    }
  }

  // Look for floating action button
  final fab = find.byType(FloatingActionButton);
  if (fab.evaluate().isNotEmpty) {
    await tester.tap(fab);
    await tester.pumpAndSettle();
    await takeScreenshot(binding, '${userType}_08_fab_action');

    // Close any dialogs or go back
    Finder backButton = find.byIcon(Icons.arrow_back);
    if (backButton.evaluate().isEmpty) {
      backButton = find.byIcon(Icons.close);
    }
    if (backButton.evaluate().isNotEmpty) {
      await tester.tap(backButton);
      await tester.pumpAndSettle();
    }
  }
}

Future<void> captureNavigationFlow(WidgetTester tester,
    IntegrationTestWidgetsFlutterBinding binding, String userType) async {
  print('Capturing navigation flow for $userType...');

  // Bottom Navigation
  final navigationBar = find.byType(NavigationBar);
  final bottomNavBar = find.byType(BottomNavigationBar);

  if (navigationBar.evaluate().isNotEmpty) {
    final destinations = find.descendant(
      of: navigationBar,
      matching: find.byType(NavigationDestination),
    );

    for (int i = 0; i < destinations.evaluate().length && i < 5; i++) {
      await tester.tap(destinations.at(i));
      await tester.pumpAndSettle();
      await takeScreenshot(binding, '${userType}_09_nav_${i + 1}');
    }
  } else if (bottomNavBar.evaluate().isNotEmpty) {
    // Handle legacy bottom navigation
    for (int i = 0; i < 4; i++) {
      try {
        await tester.tap(bottomNavBar);
        await tester.pumpAndSettle();
        await takeScreenshot(binding, '${userType}_09_nav_${i + 1}');
      } catch (e) {
        print('Could not tap navigation item $i: $e');
      }
    }
  }

  // Drawer Navigation
  final drawerButton = find.byIcon(Icons.menu);
  if (drawerButton.evaluate().isNotEmpty) {
    await tester.tap(drawerButton);
    await tester.pumpAndSettle();
    await takeScreenshot(binding, '${userType}_10_drawer');

    // Close drawer
    await tester.tap(find.byType(Scaffold));
    await tester.pumpAndSettle();
  }
}

Future<void> captureProfileFlow(WidgetTester tester,
    IntegrationTestWidgetsFlutterBinding binding, String userType) async {
  print('Capturing profile flow for $userType...');

  // Look for profile tab or icon
  Finder profileFinder = find.text('Profile');
  if (profileFinder.evaluate().isEmpty) {
    profileFinder = find.byIcon(Icons.person);
  }
  if (profileFinder.evaluate().isNotEmpty) {
    await tester.tap(profileFinder);
    await tester.pumpAndSettle();
    await takeScreenshot(binding, '${userType}_11_profile');
  }
}

Future<void> captureSettingsFlow(WidgetTester tester,
    IntegrationTestWidgetsFlutterBinding binding, String userType) async {
  print('Capturing settings flow for $userType...');

  // Look for settings
  Finder settingsFinder = find.text('Settings');
  if (settingsFinder.evaluate().isEmpty) {
    settingsFinder = find.byIcon(Icons.settings);
  }
  if (settingsFinder.evaluate().isNotEmpty) {
    await tester.tap(settingsFinder);
    await tester.pumpAndSettle();
    await takeScreenshot(binding, '${userType}_12_settings');
  }
}

Future<void> takeScreenshot(
    IntegrationTestWidgetsFlutterBinding binding, String name) async {
  try {
    await binding.convertFlutterSurfaceToImage();
    await binding.takeScreenshot(name);
    print('✓ Screenshot saved: $name');
  } catch (e) {
    print('✗ Failed to take screenshot $name: $e');
  }
}
