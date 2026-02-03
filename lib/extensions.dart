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
    Color color, {
    Color strokeColor = Colors.transparent,
    double strokeWidth = 0.0,
    double radius = 0.0,
        Key? key,
  }) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        border: Border.all(width: strokeWidth, color: strokeColor),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        clipBehavior: Clip.hardEdge,
        child: Material(color: color, child: this),
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
  Widget setOnClickListener(GestureTapCallback? onClick, {decoration}) {
    return onClick == null
        ? this
        : Material(
            color: Colors.transparent,
            child: Ink(
              decoration: decoration,
              child: InkWell(onTap: onClick, child: this),
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
