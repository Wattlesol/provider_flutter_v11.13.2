import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/main.dart';

class FontUtils {
  // Font family constants
  static const String alexandria = 'Alexandria';
  static const String gluten = 'Gluten';

  // Get primary font (always Alexandria)
  static String get primaryFont => alexandria;

  // Get headline/attention font (Gluten for Latin script languages, Alexandria for others)
  static String get headlineFont {
    // Use Gluten for Latin script languages (English, French, German)
    const latinScriptLanguages = ['en', 'fr', 'de'];
    return latinScriptLanguages.contains(appStore.selectedLanguageCode)
        ? gluten
        : alexandria;
  }

  // Helper methods for common text styles

  /// For headlines, app bar titles, section headers
  static TextStyle headlineStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: headlineFont,
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color,
    );
  }

  /// For buttons, labels, call-to-action text (uses Gluten for EN/FR/DE, Alexandria for others)
  static TextStyle buttonStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: headlineFont,
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color,
    );
  }

  /// For body text, descriptions, general content
  static TextStyle bodyStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
    );
  }

  /// For captions, small text, secondary information
  static TextStyle captionStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
    );
  }
}
