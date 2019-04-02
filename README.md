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
InfiniteCards(
            ...
            transformToFront: yourCustomTransformToFront,
            transformToBack: yourCustomTransformToBack,
            curve: yourCustomCurve
            ...
          )
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
