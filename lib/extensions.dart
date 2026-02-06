import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'l10n/app_localizations.dart';

extension LocExtension on BuildContext {
  AppLocalizations l10n() => AppLocalizations.of(this)!;
}

extension ColorsThemeExtension on BuildContext {
  ColorScheme colors() => Theme.of(this).colorScheme;
}

extension FontsThemeExtension on BuildContext {
  TextTheme fonts() => Theme.of(this).textTheme;
}

extension RoundedRectangleWidget on Widget {
  Widget wrapInRadiusRectangle(
    Color color,
    BorderRadius radius, {
    Color strokeColor = Colors.transparent,
    double strokeWidth = 0.0,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: strokeWidth, color: strokeColor),
        borderRadius: radius,
      ),
      child: ClipRRect(
        borderRadius: radius,
        clipBehavior: Clip.hardEdge,
        child: Material(color: color, child: this),
      ),
    );
  }

  Widget wrapInRoundedRectangle(
      Color fillColor, {
        Color strokeColor = Colors.transparent,
        double strokeWidth = 0.0,
        double radius = 0.0,
      }) {
    return RepaintBoundary( // ⭐ important for overlays
      child: Material(      // ⭐ forces proper compositing on Windows
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: strokeColor, width: strokeWidth),
          ),
          child: this,
        ),
      ),
    );
  }

  Widget clipCircle() {
    return ClipOval(
      clipBehavior: Clip.hardEdge,
      child: Material(color: Colors.transparent, child: this),
    );
  }
}

extension ClickableWidget on Widget {
  Widget setOnClickListener(GestureTapCallback? onClick, {decoration, GestureTapCallback? onRightClick}) {
    return onClick == null
        ? this
        : Material(
            color: Colors.transparent,
            child: Ink(
              decoration: decoration,
              child: InkWell(onTap: onClick, onSecondaryTap: onRightClick, child: this),
            ),
          );
  }

  Widget setOnLongClickListener(GestureTapCallback onLongClick, {decoration}) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: decoration,
        child: InkWell(onLongPress: onLongClick, child: this),
      ),
    );
  }
}

extension LoadSvg on String {
  Widget loadSvgIcon({
    required double width,
    required double height,
    color = Colors.transparent,
    BlendMode blendMode = BlendMode.srcATop,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: SvgPicture.asset(
        this,
        width: width,
        height: height,
        colorFilter: ColorFilter.mode(color, blendMode),
      ),
    );
  }
}
