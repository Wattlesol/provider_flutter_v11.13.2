#!/bin/bash

# Flutter App Screenshot Generator
# This script runs integration tests to capture screenshots of all app screens

echo "🚀 Starting Flutter App Screenshot Generation..."

# Create screenshots directory
mkdir -p screenshots

# Check if device/emulator is connected
echo "📱 Checking for connected devices..."
flutter devices

# Run the screenshot tests
echo "📸 Running screenshot tests..."

# Option 1: Run on connected device/emulator
echo "Running basic screenshot test (Handyman flow)..."
flutter test integration_test/screenshot_test.dart --verbose

echo "Running advanced screenshot tests (Provider & Handyman flows)..."
flutter test integration_test/advanced_screenshot_test.dart --verbose

# Option 2: Run with specific device (uncomment and modify as needed)
# flutter test integration_test/screenshot_test.dart -d "device_id" --verbose

echo "✅ Screenshot generation completed!"
echo "📁 Screenshots should be saved in the test results directory"

# Note: Screenshots are typically saved in:
# - build/app/outputs/connected_android_test_additional_output/debugAndroidTest/connected/
# - Or in the flutter test output directory

echo ""
echo "💡 Tips:"
echo "1. Make sure you have a device/emulator running"
echo "2. Screenshots are saved in the Flutter test output directory"
echo "3. You may need to modify the test credentials in the test files"
echo "4. For iOS, run: flutter test integration_test/screenshot_test.dart -d ios"
echo "5. For Android, run: flutter test integration_test/screenshot_test.dart -d android"
