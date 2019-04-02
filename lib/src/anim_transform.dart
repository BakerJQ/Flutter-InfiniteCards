import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'card_item.dart';

typedef AnimTransform = Transform Function(
    Widget item,
    double fraction,
    double interpolatorFraction,
    double cardHeight,
    double cardWidth,
    int fromPosition,
    int toPosition);

typedef ZIndexTransform = void Function(
    CardItem card,
    double fraction,
    double interpolatorFraction,
    double cardWidth,
    double cardHeight,
    int fromPosition,
    int toPosition);

const AnimTransform DefaultCommonTransform = _defaultCommonTransform,
    DefaultAddTransform = _defaultAddTransform,
    DefaultRemoveTransform = _defaultRemoveTransform,
    DefaultToBackTransform = _defaultToBackTransform,
    DefaultToFrontTransform = _defaultToFrontTransform;

const ZIndexTransform DefaultCommonZIndexTransform =
        _defaultCommonZIndexTransform,
    DefaultToFrontZIndexTransform = _defaultToFrontZIndexTransform;

const Curve DefaultCurve = _DefaultCurve();

Transform _defaultCommonTransform(
    Widget item,
    double fraction,
    double interpolatorFraction,
    double cardHeight,
    double cardWidth,
    int fromPosition,
    int toPosition) {
  int positionCount = fromPosition - toPosition;
  double scale = (0.8 - 0.1 * fromPosition) + (0.1 * fraction * positionCount);
  double translationY = -cardHeight * (0.8 - scale) * 0.5 -
      cardHeight * (0.02 * fromPosition - 0.02 * fraction * positionCount);
  return Transform.translate(
    offset: Offset(0, translationY),
    child: Transform.scale(
      scale: scale,
      child: item,
    ),
  );
}

Transform _defaultAddTransform(
    Widget item,
    double fraction,
    double interpolatorFraction,
    double cardHeight,
    double cardWidth,
    int fromPosition,
    int toPosition) {
  int positionCount = fromPosition - toPosition;
  double scale = (0.8 - 0.1 * fromPosition) + (0.1 * fraction * positionCount);
  double translationY = -cardHeight * (0.8 - scale) * 0.5 -
      cardHeight * (0.02 * fromPosition - 0.02 * fraction * positionCount);
  double opacity = fraction;
  return Transform.translate(
    offset: Offset(0, translationY),
    child: Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity,
        child: item,
      ),
    ),
  );
}

Transform _defaultRemoveTransform(
    Widget item,
    double fraction,
    double interpolatorFraction,
    double cardHeight,
    double cardWidth,
    int fromPosition,
    int toPosition) {
  double scale = (0.8 - 0.1 * fromPosition);
  double translationY = -cardHeight * (0.8 - scale) * 0.5 -
      cardHeight * 0.02 * fromPosition +
      cardHeight * fraction;
  double opacity = 1 - fraction;
  return Transform.translate(
    offset: Offset(0, translationY),
    child: Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity,
        child: item,
      ),
    ),
  );
}

Transform _defaultToBackTransform(
    Widget item,
    double fraction,
    double interpolatorFraction,
    double cardHeight,
    double cardWidth,
    int fromPosition,
    int toPosition) {
  int positionCount = fromPosition - toPosition;
  double scale = (0.8 - 0.1 * fromPosition) + (0.1 * fraction * positionCount);
  double rotateX;
  if (fraction < 0.5) {
    rotateX = -math.pi * fraction;
  } else {
    rotateX = -math.pi * (1 - fraction);
  }
  double interpolatorScale =
      0.8 - 0.1 * fromPosition + (0.1 * interpolatorFraction * positionCount);
  double translationY = -cardHeight * (0.8 - interpolatorScale) * 0.5 -
      cardHeight * (0.02 * fromPosition - 0.02 * interpolatorFraction * positionCount);
  return Transform.translate(
    offset: Offset(0, translationY),
    child: Transform.scale(
      scale: scale,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.002)
          ..rotateX(rotateX),
        alignment: Alignment.center,
        child: item,
      ),
    ),
  );
}

Transform _defaultToFrontTransform(
    Widget item,
    double fraction,
    double interpolatorFraction,
    double cardHeight,
    double cardWidth,
    int fromPosition,
    int toPosition) {
  int positionCount = fromPosition - toPosition;
  double scale = (0.8 - 0.1 * fromPosition) + (0.1 * fraction * positionCount);
  double rotateX = -math.pi * (1 - fraction);
  double translationY;
  if (fraction < 0.5) {
    translationY = -cardHeight * (0.8 - scale) * 0.5 -
        cardHeight * 0.02 * fromPosition -
        cardHeight * fraction;
  } else {
    translationY = -cardHeight * (0.8 - scale) * 0.5 -
        cardHeight * (0.02 * fromPosition - 0.02 * fraction * positionCount) -
        cardHeight * (1 - fraction);
  }
  return Transform.translate(
    offset: Offset(0, translationY),
    child: Transform.scale(
      scale: scale,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.002)
          ..rotateX(rotateX),
        alignment: Alignment.center,
        child: item,
      ),
    ),
  );
}

void _defaultCommonZIndexTransform(
    CardItem card,
    double fraction,
    double interpolatorFraction,
    double cardWidth,
    double cardHeight,
    int fromPosition,
    int toPosition) {
  card.zIndex =
      1 + 0.01 * fromPosition + 0.01 * (toPosition - fromPosition) * fraction;
}

void _defaultToFrontZIndexTransform(
    CardItem card,
    double fraction,
    double interpolatorFraction,
    double cardWidth,
    double cardHeight,
    int fromPosition,
    int toPosition) {
  if (fraction < 0.5) {
    card.zIndex = 1 + 0.01 * fromPosition;
  } else {
    card.zIndex = 1 + 0.01 * toPosition;
  }
}

class _DefaultCurve extends Curve {
  const _DefaultCurve();

  @override
  double transform(double t) {
    t -= 1.0;
    return t * t * ((-18 + 1) * t + -18) + 1.0;
  }
}
