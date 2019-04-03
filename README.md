# InfiniteCards
[![License](https://img.shields.io/badge/license-Apache%202-4EB1BA.svg)](https://www.apache.org/licenses/LICENSE-2.0.html)

An infinite card switching UI for Flutter, support custom animation
可自定义动效的卡片切换视图（[中文文档](https://github.com/BakerJQ/Flutter-InfiniteCards/blob/master/README_cn.md)）

## Android version
https://github.com/BakerJQ/Android-InfiniteCards

## Screenshot
| Android | iOS |
| :------: | :------: |
| ![](https://raw.githubusercontent.com/BakerJQ/Flutter-InfiniteCards/master/screenshot/android.gif) | ![](https://raw.githubusercontent.com/BakerJQ/Flutter-InfiniteCards/master/screenshot/ios.gif) |

## Example
```
cd ./example
flutter create .
flutter run
```

## How to use

### Add dependencies
```yaml
dependencies:
  infinite_cards: ^1.0.2
```

### Build controller in initState
```dart
@override
  void initState() {
    super.initState();
    _controller = InfiniteCardsController(
      itemBuilder: _renderItem,
      itemCount: 5,
      animType: AnimType.SWITCH,
    );
  }
```

- animType : animation type
  - TO_FRONT : move the selected card to first
  - SWITCH : move the selected card to first, and the first card to the selected position
  - TO_END : move the first card to last position

### Build widget with controller
```dart
InfiniteCards(
  controller: _controller,
)
```

### Call methods from controller
```dart
  _controller.previous();
  _controller.next();
  _controller.reset(...);
```

### Animation transform and curve
#### Default
If you just use all default animations, just do nothing.

#### Customisation
```dart
InfiniteCardsController(
            ...
            transformToFront: yourCustomTransformToFront,
            transformToBack: yourCustomTransformToBack,
            curve: yourCustomCurve
            ...
          )
```
One example of implement Transform
```dart
Transform _defaultCommonTransform(Widget item, 
    double fraction, double curveFraction, double cardHeight, double cardWidth, int fromPosition, int toPosition) 
  {
  //Count of card which needs to move over
  int positionCount = fromPosition - toPosition;
  //0.8 scale for the first card, and -0.1 per card behind
  //(0.8 - 0.1 * fromPosition) = current specific card scale
  //(0.1 * fraction * positionCount) = scale while moving
  double scale = (0.8 - 0.1 * fromPosition) + (0.1 * fraction * positionCount);
  //translate -0.02 * cardHeight per card behind
  //-cardHeight * (0.8 - scale) * 0.5 to center the card
  double translationY = -cardHeight * (0.8 - scale) * 0.5 -
      cardHeight * (0.02 * fromPosition - 0.02 * fraction * positionCount);
  //return the Widget after scale and translate
  return Transform.translate(
    offset: Offset(0, translationY),
    child: Transform.scale(
      scale: scale,
      child: item,
    ),
  );
}
```
## *License*
InfiniteCards is released under the Apache 2.0 license.

```
Copyright 2019 BakerJ.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at following link.

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
