# InfiniteCards
[![License](https://img.shields.io/badge/license-Apache%202-4EB1BA.svg)](https://www.apache.org/licenses/LICENSE-2.0.html)
[![pub package](https://img.shields.io/pub/v/infinite_cards.svg)](https://pub.dartlang.org/packages/infinite_cards)

可自定义动效的卡片切换视图

实现思路：https://juejin.im/post/5ca375f3e51d451a18362e2a

## Android版本
https://github.com/BakerJQ/Android-InfiniteCards

## Flutter for Web版本
https://github.com/BakerJQ/Flutter-InfiniteCards/tree/web

## 截图
| Android | iOS |
| :------: | :------: |
| ![](https://raw.githubusercontent.com/BakerJQ/Flutter-InfiniteCards/master/screenshot/android.gif) | ![](https://raw.githubusercontent.com/BakerJQ/Flutter-InfiniteCards/master/screenshot/ios.gif) |

## 示例运行
```
cd ./example
flutter create .
flutter run
```

## 如何使用

### 添加依赖
```yaml
dependencies:
  infinite_cards: ^1.0.3
```

### 构建Controller
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
- animType : 动效展示类型
  - TO_FRONT : 将点击的卡片切换到第一个
  - SWITCH : 将点击的卡片和第一张卡片互换位置
  - TO_END : 将第一张卡片移到最后，后面的卡片往前移动一个

### 构建Widget
```dart
InfiniteCards(
  controller: _controller,
)
```

### 调用Controller方法
```dart
  _controller.previous();
  _controller.next();
  _controller.reset(...);
```

### 自定义动效
#### 默认
默认动效无需任何配置

#### 自定义
```dart
InfiniteCardsController(
            ...
            transformToFront: yourCustomTransformToFront,
            transformToBack: yourCustomTransformToBack,
            curve: yourCustomCurve
            ...
          )
```
实现Transform的一个例子
```dart
Transform _defaultCommonTransform(Widget item, 
    double fraction, double curveFraction, double cardHeight, double cardWidth, int fromPosition, int toPosition) 
  //需要跨越的卡片数量{
  int positionCount = fromPosition - toPosition;
  //以0.8做为第一张的缩放尺寸，每向后一张缩小0.1
  //(0.8 - 0.1 * fromPosition) = 当前位置的缩放尺寸
  //(0.1 * fraction * positionCount) = 移动过程中需要改变的缩放尺寸 
  double scale = (0.8 - 0.1 * fromPosition) + (0.1 * fraction * positionCount);
  //在Y方向的偏移量，每向后一张，向上偏移卡片宽度的0.02
  //-cardHeight * (0.8 - scale) * 0.5 对卡片做整体居中处理
  double translationY = -cardHeight * (0.8 - scale) * 0.5 -
      cardHeight * (0.02 * fromPosition - 0.02 * fraction * positionCount);
  //返回缩放后，进行Y方向偏移的Widget
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
