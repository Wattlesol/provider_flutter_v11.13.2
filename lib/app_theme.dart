import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:nb_utils/nb_utils.dart';

// Custom theme extension for brand colors
@immutable
class BrandColors extends ThemeExtension<BrandColors> {
  const BrandColors({
    required this.brandYellow,
    required this.brandRed,
    required this.brandGreen,
    required this.brandBlue,
  });

  final Color brandYellow;
  final Color brandRed;
  final Color brandGreen;
  final Color brandBlue;

  @override
  BrandColors copyWith({
    Color? brandYellow,
    Color? brandRed,
    Color? brandGreen,
    Color? brandBlue,
  }) {
    return BrandColors(
      brandYellow: brandYellow ?? this.brandYellow,
      brandRed: brandRed ?? this.brandRed,
      brandGreen: brandGreen ?? this.brandGreen,
      brandBlue: brandBlue ?? this.brandBlue,
    );
  }

  @override
  BrandColors lerp(BrandColors? other, double t) {
    if (other is! BrandColors) {
      return this;
    }
    return BrandColors(
      brandYellow: Color.lerp(brandYellow, other.brandYellow, t)!,
      brandRed: Color.lerp(brandRed, other.brandRed, t)!,
      brandGreen: Color.lerp(brandGreen, other.brandGreen, t)!,
      brandBlue: Color.lerp(brandBlue, other.brandBlue, t)!,
    );
  }

  // Light theme colors
  static const light = BrandColors(
    brandYellow: brandYellowLight,
    brandRed: brandRedLight,
    brandGreen: brandGreenLight,
    brandBlue: brandBlueLight,
  );

  // Dark theme colors
  static const dark = BrandColors(
    brandYellow: brandYellowDark,
    brandRed: brandRedDark,
    brandGreen: brandGreenDark,
    brandBlue: brandBlueDark,
  );
}

// Extension to easily access brand colors from BuildContext
extension BrandColorsExtension on BuildContext {
  BrandColors get brandColors => Theme.of(this).extension<BrandColors>()!;
}

class AppTheme {
  //
  AppTheme._();

  // Font family getters based on language
  static String get primaryFontFamily => 'Alexandria';
  static String get headlineFontFamily {
    // Use Gluten for Latin script languages (English, French, German)
    const latinScriptLanguages = ['en', 'fr', 'de'];
    return latinScriptLanguages.contains(appStore.selectedLanguageCode)
        ? 'Gluten'
        : 'Alexandria';
  }

  // Custom text theme with our fonts
  static TextTheme get customTextTheme => TextTheme(
        // Headlines - Use Gluten for English, Alexandria for others
        displayLarge: TextStyle(
            fontFamily: headlineFontFamily, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(
            fontFamily: headlineFontFamily, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(
            fontFamily: headlineFontFamily, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(
            fontFamily: headlineFontFamily, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(
            fontFamily: headlineFontFamily, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(
            fontFamily: headlineFontFamily, fontWeight: FontWeight.w600),

        // Titles - Use Gluten for English, Alexandria for others
        titleLarge: TextStyle(
            fontFamily: headlineFontFamily, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(
            fontFamily: headlineFontFamily, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(
            fontFamily: headlineFontFamily, fontWeight: FontWeight.w500),

        // Body text - Always Alexandria
        bodyLarge: TextStyle(
            fontFamily: primaryFontFamily, fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(
            fontFamily: primaryFontFamily, fontWeight: FontWeight.normal),
        bodySmall: TextStyle(
            fontFamily: primaryFontFamily, fontWeight: FontWeight.normal),

        // Labels - Use Gluten for English buttons, Alexandria for others
        labelLarge: TextStyle(
            fontFamily: headlineFontFamily, fontWeight: FontWeight.w600),
        labelMedium: TextStyle(
            fontFamily: headlineFontFamily, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(
            fontFamily: primaryFontFamily, fontWeight: FontWeight.normal),
      );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primarySwatch: createMaterialColor(primaryColor),
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      outlineVariant: borderColor,
    ),
    scaffoldBackgroundColor: Colors.white,
    fontFamily: primaryFontFamily,
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: Colors.white),
    iconTheme: IconThemeData(color: appTextSecondaryColor),
    textTheme: customTextTheme,
    unselectedWidgetColor: Colors.black,
    dividerColor: borderColor,
    extensions: <ThemeExtension<dynamic>>[
      BrandColors.light,
    ],
    bottomSheetTheme: BottomSheetThemeData(
      shape: RoundedRectangleBorder(
          borderRadius:
              radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
      backgroundColor: Colors.white,
    ),
    cardColor: cardColor,
    appBarTheme: AppBarTheme(
        backgroundColor: null, // Use dynamic primaryColor
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: headlineFontFamily,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarColor: null)), // Use dynamic primaryColor
    dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: dialogShape()),
    navigationBarTheme: NavigationBarThemeData(
        labelTextStyle: WidgetStateProperty.all(primaryTextStyle(size: 10))),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all(Colors.white),
      fillColor: WidgetStateProperty.all(Colors.white),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    primarySwatch: createMaterialColor(primaryColor),
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      brightness: Brightness.dark,
      outlineVariant: borderColor.withValues(alpha: 0.4),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: null, // Use dynamic primaryColor
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: headlineFontFamily,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: null), // Use dynamic primaryColor
    ),
    scaffoldBackgroundColor: scaffoldColorDark,
    fontFamily: primaryFontFamily,
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: scaffoldSecondaryDark),
    iconTheme: IconThemeData(color: Colors.white),
    textTheme: customTextTheme,
    unselectedWidgetColor: Colors.white60,
    bottomSheetTheme: BottomSheetThemeData(
      shape: RoundedRectangleBorder(
          borderRadius:
              radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
      backgroundColor: scaffoldSecondaryDark,
    ),
    dividerColor: dividerDarkColor,
    cardColor: scaffoldSecondaryDark,
    dialogTheme: DialogThemeData(
        backgroundColor: scaffoldSecondaryDark,
        surfaceTintColor: Colors.transparent,
        shape: dialogShape()),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all(Colors.white),
      fillColor: WidgetStateProperty.all(Colors.white),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
        labelTextStyle: WidgetStateProperty.all(
            primaryTextStyle(size: 10, color: Colors.white))),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    extensions: <ThemeExtension<dynamic>>[
      BrandColors.dark,
    ],
  );
}
