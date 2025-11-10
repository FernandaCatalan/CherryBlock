import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff970011),
      surfaceTint: Color(0xffba1a20),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffbd1d22),
      onPrimaryContainer: Color(0xffffd1cd),
      secondary: Color(0xff9a433d),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffff9289),
      onSecondaryContainer: Color(0xff772925),
      tertiary: Color(0xff060300),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff291b00),
      onTertiaryContainer: Color(0xff99825a),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff271816),
      onSurfaceVariant: Color(0xff5b403d),
      outline: Color(0xff8f6f6c),
      outlineVariant: Color(0xffe4beba),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3e2c2a),
      inversePrimary: Color(0xffffb3ac),
      primaryFixed: Color(0xffffdad6),
      onPrimaryFixed: Color(0xff410003),
      primaryFixedDim: Color(0xffffb3ac),
      onPrimaryFixedVariant: Color(0xff930010),
      secondaryFixed: Color(0xffffdad6),
      onSecondaryFixed: Color(0xff400104),
      secondaryFixedDim: Color(0xffffb3ac),
      onSecondaryFixedVariant: Color(0xff7c2c28),
      tertiaryFixed: Color(0xfffbdfb0),
      onTertiaryFixed: Color(0xff271900),
      tertiaryFixedDim: Color(0xffdec396),
      onTertiaryFixedVariant: Color(0xff564421),
      surfaceDim: Color(0xfff1d3d0),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0ef),
      surfaceContainer: Color(0xffffe9e7),
      surfaceContainerHigh: Color(0xffffe2de),
      surfaceContainerHighest: Color(0xfff9dcd9),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff73000a),
      surfaceTint: Color(0xffba1a20),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffbd1d22),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff661c19),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffad514b),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff060300),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff291b00),
      onTertiaryContainer: Color(0xffbea57a),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff1c0d0c),
      onSurfaceVariant: Color(0xff49302d),
      outline: Color(0xff684b49),
      outlineVariant: Color(0xff856662),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3e2c2a),
      inversePrimary: Color(0xffffb3ac),
      primaryFixed: Color(0xffcf2c2d),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xffab0b18),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xffad514b),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff8e3a35),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff7f6a43),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff65522e),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffdcc0bd),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0ef),
      surfaceContainer: Color(0xffffe2de),
      surfaceContainerHigh: Color(0xfff4d6d3),
      surfaceContainerHighest: Color(0xffe8cbc8),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff600007),
      surfaceTint: Color(0xffba1a20),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff980011),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff581110),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff7f2e2a),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff060300),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff291b00),
      onTertiaryContainer: Color(0xffeacfa1),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff3e2624),
      outlineVariant: Color(0xff5e4240),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3e2c2a),
      inversePrimary: Color(0xffffb3ac),
      primaryFixed: Color(0xff980011),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff6d0009),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff7f2e2a),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff611816),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff594623),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff40300f),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffceb3b0),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffffedeb),
      surfaceContainer: Color(0xfff9dcd9),
      surfaceContainerHigh: Color(0xffebcecb),
      surfaceContainerHighest: Color(0xffdcc0bd),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFB22222),
      surfaceTint: Color(0xFFFF80AB),
      onPrimary: Color.fromARGB(255, 254, 249, 250),
      primaryContainer: Color(0xffbd1d22),
      onPrimaryContainer: Color(0xffffd1cd),
      secondary: Color(0xffffbbb5),
      onSecondary: Color(0xff5e1614),
      secondaryContainer: Color(0xFFFF80AB),
      onSecondaryContainer: Color(0xff772925),
      tertiary: Color(0xffdec396),
      onTertiary: Color(0xff3e2e0d),
      tertiaryContainer: Color(0xff291b00),
      onTertiaryContainer: Color(0xff99825a),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff1e0f0e),
      onSurface: Color(0xfff9dcd9),
      onSurfaceVariant: Color(0xffe4beba),
      outline: Color(0xffab8985),
      outlineVariant: Color(0xff5b403d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff9dcd9),
      inversePrimary: Color(0xffba1a20),
      primaryFixed: Color(0xffffdad6),
      onPrimaryFixed: Color(0xff410003),
      primaryFixedDim: Color(0xffffb3ac),
      onPrimaryFixedVariant: Color(0xff930010),
      secondaryFixed: Color(0xffffdad6),
      onSecondaryFixed: Color(0xff400104),
      secondaryFixedDim: Color(0xffffb3ac),
      onSecondaryFixedVariant: Color(0xff7c2c28),
      tertiaryFixed: Color(0xfffbdfb0),
      onTertiaryFixed: Color(0xff271900),
      tertiaryFixedDim: Color(0xffdec396),
      onTertiaryFixedVariant: Color(0xff564421),
      surfaceDim: Color(0xff1e0f0e),
      surfaceBright: Color(0xff473533),
      surfaceContainerLowest: Color(0xff180a09),
      surfaceContainerLow: Color(0xff271816),
      surfaceContainer: Color(0xff2c1b1a),
      surfaceContainerHigh: Color(0xff372624),
      surfaceContainerHighest: Color(0xff43302e),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffd2cd),
      surfaceTint: Color(0xffffb3ac),
      onPrimary: Color(0xff540005),
      primaryContainer: Color(0xffff544e),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffffd2cd),
      onSecondary: Color(0xff4f0a0b),
      secondaryContainer: Color(0xffff9289),
      onSecondaryContainer: Color(0xff4e0a0a),
      tertiary: Color(0xfff5d9aa),
      onTertiary: Color(0xff322304),
      tertiaryContainer: Color(0xffa58d64),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1e0f0e),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfffbd3cf),
      outline: Color(0xffcea9a6),
      outlineVariant: Color(0xffaa8885),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff9dcd9),
      inversePrimary: Color(0xff950010),
      primaryFixed: Color(0xffffdad6),
      onPrimaryFixed: Color(0xff2d0001),
      primaryFixedDim: Color(0xffffb3ac),
      onPrimaryFixedVariant: Color(0xff73000a),
      secondaryFixed: Color(0xffffdad6),
      onSecondaryFixed: Color(0xff2d0002),
      secondaryFixedDim: Color(0xffffb3ac),
      onSecondaryFixedVariant: Color(0xff661c19),
      tertiaryFixed: Color(0xfffbdfb0),
      onTertiaryFixed: Color(0xff190f00),
      tertiaryFixedDim: Color(0xffdec396),
      onTertiaryFixedVariant: Color(0xff443412),
      surfaceDim: Color(0xff1e0f0e),
      surfaceBright: Color(0xff53403e),
      surfaceContainerLowest: Color(0xff100504),
      surfaceContainerLow: Color(0xff291918),
      surfaceContainer: Color(0xff352422),
      surfaceContainerHigh: Color(0xff402e2c),
      surfaceContainerHighest: Color(0xff4c3937),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffecea),
      surfaceTint: Color(0xffffb3ac),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffaea6),
      onPrimaryContainer: Color(0xff220001),
      secondary: Color(0xffffecea),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffffaea6),
      onSecondaryContainer: Color(0xff220001),
      tertiary: Color(0xffffeed4),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffdabf92),
      onTertiaryContainer: Color(0xff120a00),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff1e0f0e),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffffecea),
      outlineVariant: Color(0xffe0bab6),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff9dcd9),
      inversePrimary: Color(0xff950010),
      primaryFixed: Color(0xffffdad6),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffb3ac),
      onPrimaryFixedVariant: Color(0xff2d0001),
      secondaryFixed: Color(0xffffdad6),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffffb3ac),
      onSecondaryFixedVariant: Color(0xff2d0002),
      tertiaryFixed: Color(0xfffbdfb0),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffdec396),
      onTertiaryFixedVariant: Color(0xff190f00),
      surfaceDim: Color(0xff1e0f0e),
      surfaceBright: Color(0xff604b49),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff2c1b1a),
      surfaceContainer: Color(0xff3e2c2a),
      surfaceContainerHigh: Color(0xff4a3735),
      surfaceContainerHighest: Color(0xff564240),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
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
