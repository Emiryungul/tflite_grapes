import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Light theme configuration
  static ThemeData get lightTheme {
    return FlexThemeData.light(
      scheme: FlexScheme.wasabi,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 9,
      subThemesData: FlexSubThemesData(
        blendOnLevel: 10,
        blendOnColors: false,
        useM2StyleDividerInM3: true,
        elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
        elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
        filledButtonSchemeColor: SchemeColor.primary,
        outlinedButtonOutlineSchemeColor: SchemeColor.outline,
        toggleButtonsBorderSchemeColor: SchemeColor.outline,
        segmentedButtonSchemeColor: SchemeColor.outline,
        segmentedButtonBorderSchemeColor: SchemeColor.outline,
        unselectedToggleIsColored: true,
        sliderBaseSchemeColor: SchemeColor.primary,
        sliderIndicatorSchemeColor: SchemeColor.onPrimary,
        inputDecoratorSchemeColor: SchemeColor.primary,
        inputDecoratorBorderSchemeColor: SchemeColor.outline,
        inputDecoratorFocusedHasBorder: true,
        inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
        popupMenuRadius: 8,
        popupMenuElevation: 3,
        alignedDropdown: true,
        useInputDecoratorThemeInDialogs: true,
        drawerIndicatorSchemeColor: SchemeColor.primary,
        bottomNavigationBarMutedUnselectedLabel: false,
        bottomNavigationBarMutedUnselectedIcon: false,
        menuBarBackgroundSchemeColor: SchemeColor.surface,
        navigationBarIndicatorSchemeColor: SchemeColor.primary,
        navigationBarMutedUnselectedLabel: false,
        navigationBarMutedUnselectedIcon: false,
        navigationRailIndicatorSchemeColor: SchemeColor.primary,
        navigationRailMutedUnselectedLabel: false,
        navigationRailMutedUnselectedIcon: false,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      fontFamily: GoogleFonts.notoSans().fontFamily,
    );
  }

  // Dark theme configuration
  static ThemeData get darkTheme {
    return FlexThemeData.dark(
      scheme: FlexScheme.wasabi,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 15,
      subThemesData: FlexSubThemesData(
        blendOnLevel: 20,
        useM2StyleDividerInM3: true,
        elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
        elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
        filledButtonSchemeColor: SchemeColor.primary,
        outlinedButtonOutlineSchemeColor: SchemeColor.outline,
        toggleButtonsBorderSchemeColor: SchemeColor.outline,
        segmentedButtonSchemeColor: SchemeColor.outline,
        segmentedButtonBorderSchemeColor: SchemeColor.outline,
        unselectedToggleIsColored: true,
        sliderBaseSchemeColor: SchemeColor.primary,
        sliderIndicatorSchemeColor: SchemeColor.onPrimary,
        inputDecoratorSchemeColor: SchemeColor.primary,
        inputDecoratorBorderSchemeColor: SchemeColor.outline,
        inputDecoratorFocusedHasBorder: true,
        inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
        popupMenuRadius: 8,
        popupMenuElevation: 3,
        alignedDropdown: true,
        useInputDecoratorThemeInDialogs: true,
        drawerIndicatorSchemeColor: SchemeColor.primary,
        bottomNavigationBarMutedUnselectedLabel: false,
        bottomNavigationBarMutedUnselectedIcon: false,
        menuBarBackgroundSchemeColor: SchemeColor.surface,
        navigationBarIndicatorSchemeColor: SchemeColor.primary,
        navigationBarMutedUnselectedLabel: false,
        navigationBarMutedUnselectedIcon: false,
        navigationRailIndicatorSchemeColor: SchemeColor.primary,
        navigationRailMutedUnselectedLabel: false,
        navigationRailMutedUnselectedIcon: false,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      fontFamily: GoogleFonts.notoSans().fontFamily,
    );
  }
}
