# 📸 Flutter App Screenshot Guide

This guide provides multiple methods to capture screenshots of every screen and flow in your Flutter app.

## 🚀 Quick Start

### Method 1: Automated Integration Tests (Recommended)

1. **Run the screenshot script:**
   ```bash
   ./take_screenshots.sh
   ```

2. **Or run tests manually:**
   ```bash
   # Basic screenshot test
   flutter test integration_test/screenshot_test.dart
   
   # Advanced comprehensive test
   flutter test integration_test/advanced_screenshot_test.dart
   ```

### Method 2: Manual Screenshots with Helper

1. **Add screenshot helper to your app** (modify `main.dart`):
   ```dart
   import 'utils/screenshot_helper.dart';
   
   // Wrap your MaterialApp
   return ScreenshotHelper.wrapApp(
     MaterialApp(
       // your app configuration
     ),
   );
   ```

2. **Add floating screenshot button** to any screen:
   ```dart
   Stack(
     children: [
       // Your screen content
       YourScreenContent(),
       
       // Screenshot button
       ScreenshotButton(),
     ],
   )
   ```

3. **Take screenshots programmatically:**
   ```dart
   // Take a single screenshot
   await ScreenshotHelper.takeScreenshot(fileName: 'login_screen.png');
   
   // Take multiple screenshots
   await ScreenshotHelper.takeMultipleScreenshots(
     screenNames: ['home', 'profile', 'settings'],
   );
   ```

## 📱 Device Setup

### Android
```bash
# List connected devices
flutter devices

# Run on specific Android device
flutter test integration_test/screenshot_test.dart -d android

# Run on Android emulator
flutter test integration_test/screenshot_test.dart -d emulator-5554
```

### iOS
```bash
# Run on iOS simulator
flutter test integration_test/screenshot_test.dart -d ios

# Run on specific iOS device
flutter test integration_test/screenshot_test.dart -d "iPhone 14"
```

## 🎯 What Gets Captured

### Automated Tests Capture:
- ✅ Splash screen
- ✅ Authentication flow (Sign in, Sign up, Forgot password)
- ✅ Dashboard/Home screens
- ✅ All bottom navigation tabs
- ✅ Drawer navigation (if available)
- ✅ Profile screens
- ✅ Settings screens
- ✅ Card/List item details
- ✅ Modal dialogs and bottom sheets

### User Flows Covered:
- 🔐 **Authentication Flow**: Login, registration, password recovery
- 🏠 **Provider Dashboard**: Home, bookings, chat, profile
- 🔧 **Handyman Dashboard**: Home, bookings, chat, profile
- 📱 **Navigation**: Bottom tabs, drawer menu, back navigation
- 👤 **Profile Management**: View profile, edit profile, settings
- 💬 **Chat Interface**: Chat list, individual conversations
- 📋 **Booking Management**: Booking list, booking details
- ⚙️ **Settings**: App settings, preferences, account settings

## 📁 Screenshot Locations

Screenshots are saved in different locations depending on the method:

### Integration Tests:
- **Android**: `build/app/outputs/connected_android_test_additional_output/`
- **iOS**: Test output directory in Xcode
- **Desktop**: Flutter test output directory

### Manual Helper:
- **All Platforms**: `Documents/screenshots/` directory

## 🛠️ Customization

### Modify Test Credentials
Edit the test files to use your actual test credentials:

```dart
// In integration_test/screenshot_test.dart
await tester.enterText(emailField, 'your-test-email@example.com');
await tester.enterText(passwordField, 'your-test-password');
```

### Add Custom Screens
Add more screens to capture in `advanced_screenshot_test.dart`:

```dart
// Add custom screen capture
await captureCustomScreen(tester, binding, userType);

Future<void> captureCustomScreen(
  WidgetTester tester, 
  IntegrationTestWidgetsFlutterBinding binding,
  String userType
) async {
  // Navigate to your custom screen
  final customButton = find.text('Custom Screen');
  if (customButton.evaluate().isNotEmpty) {
    await tester.tap(customButton);
    await tester.pumpAndSettle();
    await takeScreenshot(binding, '${userType}_custom_screen');
  }
}
```

### Screenshot Quality Settings
Modify screenshot quality in the helper:

```dart
// High quality screenshots
ui.Image image = await boundary.toImage(pixelRatio: 3.0);

// Lower quality for faster capture
ui.Image image = await boundary.toImage(pixelRatio: 1.0);
```

## 🔧 Troubleshooting

### Common Issues:

1. **No device connected**
   ```bash
   flutter devices
   # Make sure emulator/device is running
   ```

2. **Permission denied (Android)**
   - Grant storage permissions to the app
   - Or run: `adb shell pm grant com.iqonic.provider android.permission.WRITE_EXTERNAL_STORAGE`

3. **Test timeout**
   - Increase timeout in test files
   - Ensure app loads properly on test device

4. **Screenshots not found**
   - Check the output directory mentioned in test results
   - Look for `flutter_test_output` directory

### Debug Mode:
Run tests with verbose output:
```bash
flutter test integration_test/screenshot_test.dart --verbose
```

## 📊 Best Practices

1. **Use consistent naming**: Follow the pattern `usertype_##_screenname`
2. **Test on multiple devices**: Different screen sizes and orientations
3. **Include error states**: Network errors, validation errors, empty states
4. **Capture loading states**: Show spinners and progress indicators
5. **Document flows**: Keep track of what each screenshot represents

## 🎨 Advanced Features

### Capture Different Themes:
```dart
// Switch to dark mode before screenshots
appStore.setDarkMode(true);
await tester.pumpAndSettle();
await takeScreenshot(binding, 'dark_mode_home');
```

### Capture Different Languages:
```dart
// Switch language before screenshots
appStore.setLanguage('es'); // Spanish
await tester.pumpAndSettle();
await takeScreenshot(binding, 'spanish_home');
```

### Capture Different User Roles:
The tests already handle Provider vs Handyman flows separately.

---

## 🚀 Ready to Start?

1. Make sure you have a device/emulator running
2. Run: `./take_screenshots.sh`
3. Check the output directory for your screenshots
4. Customize the tests for your specific needs

Happy screenshotting! 📸
