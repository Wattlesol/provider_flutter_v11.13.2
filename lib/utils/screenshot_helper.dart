import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ScreenshotHelper {
  static final GlobalKey _globalKey = GlobalKey();
  
  /// Wrap your app with this widget to enable screenshots
  static Widget wrapApp(Widget app) {
    return RepaintBoundary(
      key: _globalKey,
      child: app,
    );
  }
  
  /// Take a screenshot of the current screen
  static Future<String?> takeScreenshot({String? fileName}) async {
    try {
      // Request storage permission
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          print('Storage permission denied');
          return null;
        }
      }
      
      // Find the render object
      RenderRepaintBoundary? boundary = _globalKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;
      
      if (boundary == null) {
        print('Could not find render boundary');
        return null;
      }
      
      // Capture the image
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) {
        print('Could not convert image to bytes');
        return null;
      }
      
      Uint8List pngBytes = byteData.buffer.asUint8List();
      
      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final screenshotsDir = Directory('${directory.path}/screenshots');
      if (!await screenshotsDir.exists()) {
        await screenshotsDir.create(recursive: true);
      }
      
      fileName ??= 'screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${screenshotsDir.path}/$fileName');
      await file.writeAsBytes(pngBytes);
      
      print('Screenshot saved: ${file.path}');
      return file.path;
      
    } catch (e) {
      print('Error taking screenshot: $e');
      return null;
    }
  }
  
  /// Take multiple screenshots with delay
  static Future<List<String>> takeMultipleScreenshots({
    required List<String> screenNames,
    Duration delay = const Duration(seconds: 2),
  }) async {
    List<String> savedPaths = [];
    
    for (String screenName in screenNames) {
      await Future.delayed(delay);
      String? path = await takeScreenshot(fileName: '$screenName.png');
      if (path != null) {
        savedPaths.add(path);
      }
    }
    
    return savedPaths;
  }
}

/// Widget to add a floating screenshot button
class ScreenshotButton extends StatelessWidget {
  final VoidCallback? onScreenshotTaken;
  
  const ScreenshotButton({Key? key, this.onScreenshotTaken}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100,
      right: 20,
      child: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.red,
        onPressed: () async {
          String? path = await ScreenshotHelper.takeScreenshot();
          if (path != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Screenshot saved!'),
                action: SnackBarAction(
                  label: 'View',
                  onPressed: () {
                    // You can implement opening the file here
                    print('Screenshot path: $path');
                  },
                ),
              ),
            );
            onScreenshotTaken?.call();
          }
        },
        child: Icon(Icons.camera_alt, color: Colors.white),
      ),
    );
  }
}

/// Mixin to add screenshot functionality to any screen
mixin ScreenshotMixin<T extends StatefulWidget> on State<T> {
  Future<void> takeScreenshot([String? screenName]) async {
    screenName ??= T.toString();
    await ScreenshotHelper.takeScreenshot(fileName: '$screenName.png');
  }
}
