import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff5d5f5f),
      surfaceTint: Color(0xff5d5f5f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xfff6f6f6),
      onPrimaryContainer: Color(0xff525354),
      secondary: Color(0xff5e5e5e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffe8e6e6),
      onSecondaryContainer: Color(0xff4a4a4a),
      tertiary: Color(0xff605e60),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xfffaf5f8),
      onTertiaryContainer: Color(0xff555355),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffcf8f8),
      onSurface: Color(0xff1c1b1b),
      onSurfaceVariant: Color(0xff444748),
      outline: Color(0xff747878),
      outlineVariant: Color(0xffc4c7c8),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313030),
      inversePrimary: Color(0xffc6c6c7),
      primaryFixed: Color(0xffe2e2e2),
      onPrimaryFixed: Color(0xff1a1c1c),
      primaryFixedDim: Color(0xffc6c6c7),
      onPrimaryFixedVariant: Color(0xff454747),
      secondaryFixed: Color(0xffe4e2e2),
      onSecondaryFixed: Color(0xff1b1c1c),
      secondaryFixedDim: Color(0xffc8c6c6),
      onSecondaryFixedVariant: Color(0xff474747),
      tertiaryFixed: Color(0xffe6e1e4),
      onTertiaryFixed: Color(0xff1c1b1d),
      tertiaryFixedDim: Color(0xffc9c5c8),
      onTertiaryFixedVariant: Color(0xff484649),
      surfaceDim: Color(0xffddd9d9),
      surfaceBright: Color(0xfffcf8f8),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6f3f2),
      surfaceContainer: Color(0xfff1edec),
      surfaceContainerHigh: Color(0xffebe7e7),
      surfaceContainerHighest: Color(0xffe5e2e1),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffffff),
      surfaceTint: Color(0xffc6c6c7),
      onPrimary: Color(0xff2f3131),
      primaryContainer: Color(0xffd4d4d4),
      onPrimaryContainer: Color(0xff3e4040),
      secondary: Color(0xffc8c6c6),
      onSecondary: Color(0xff303030),
      secondaryContainer: Color(0xff3f3f3f),
      onSecondaryContainer: Color(0xffd5d4d3),
      tertiary: Color(0xffffffff),
      onTertiary: Color(0xff313032),
      tertiaryContainer: Color(0xffd8d3d6),
      onTertiaryContainer: Color(0xff403f41),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff141313),
      onSurface: Color(0xffe5e2e1),
      onSurfaceVariant: Color(0xffc4c7c8),
      outline: Color(0xff8e9192),
      outlineVariant: Color(0xff444748),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e1),
      inversePrimary: Color(0xff5d5f5f),
      primaryFixed: Color(0xffe2e2e2),
      onPrimaryFixed: Color(0xff1a1c1c),
      primaryFixedDim: Color(0xffc6c6c7),
      onPrimaryFixedVariant: Color(0xff454747),
      secondaryFixed: Color(0xffe4e2e2),
      onSecondaryFixed: Color(0xff1b1c1c),
      secondaryFixedDim: Color(0xffc8c6c6),
      onSecondaryFixedVariant: Color(0xff474747),
      tertiaryFixed: Color(0xffe6e1e4),
      onTertiaryFixed: Color(0xff1c1b1d),
      tertiaryFixedDim: Color(0xffc9c5c8),
      onTertiaryFixedVariant: Color(0xff484649),
      surfaceDim: Color(0xff141313),
      surfaceBright: Color(0xff3a3939),
      surfaceContainerLowest: Color(0xff0e0e0e),
      surfaceContainerLow: Color(0xff1c1b1b),
      surfaceContainer: Color(0xff201f1f),
      surfaceContainerHigh: Color(0xff2a2a2a),
      surfaceContainerHighest: Color(0xff353434),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffffff),
      surfaceTint: Color(0xffc6c6c7),
      onPrimary: Color(0xff2f3131),
      primaryContainer: Color(0xffd4d4d4),
      onPrimaryContainer: Color(0xff1e2020),
      secondary: Color(0xffcccaca),
      onSecondary: Color(0xff161616),
      secondaryContainer: Color(0xff919090),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffffff),
      onTertiary: Color(0xff313032),
      tertiaryContainer: Color(0xffd8d3d6),
      onTertiaryContainer: Color(0xff201f21),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff141313),
      onSurface: Color(0xfffefaf9),
      onSurfaceVariant: Color(0xffc8cbcc),
      outline: Color(0xffa0a3a4),
      outlineVariant: Color(0xff808484),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e1),
      inversePrimary: Color(0xff464848),
      primaryFixed: Color(0xffe2e2e2),
      onPrimaryFixed: Color(0xff0f1112),
      primaryFixedDim: Color(0xffc6c6c7),
      onPrimaryFixedVariant: Color(0xff353637),
      secondaryFixed: Color(0xffe4e2e2),
      onSecondaryFixed: Color(0xff111111),
      secondaryFixedDim: Color(0xffc8c6c6),
      onSecondaryFixedVariant: Color(0xff363636),
      tertiaryFixed: Color(0xffe6e1e4),
      onTertiaryFixed: Color(0xff121113),
      tertiaryFixedDim: Color(0xffc9c5c8),
      onTertiaryFixedVariant: Color(0xff373638),
      surfaceDim: Color(0xff141313),
      surfaceBright: Color(0xff3a3939),
      surfaceContainerLowest: Color(0xff0e0e0e),
      surfaceContainerLow: Color(0xff1c1b1b),
      surfaceContainer: Color(0xff201f1f),
      surfaceContainerHigh: Color(0xff2a2a2a),
      surfaceContainerHighest: Color(0xff353434),
    );
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily dark;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.dark,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
