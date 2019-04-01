# InfiniteCards
[![License](https://img.shields.io/badge/license-Apache%202-4EB1BA.svg)](https://www.apache.org/licenses/LICENSE-2.0.html)

可自定义动效的卡片切换视图

## Android版本
https://github.com/BakerJQ/Android-InfiniteCards

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
### 构建Widget
```dart
import 'package:infinite_cards/infinite_cards.dart';

InfiniteCardsController _controller = InfiniteCardsController();
AnimType _animType = AnimType.SWITCH;

Widget _renderItem(BuildContext context, int index) {
    return Image(
      image: AssetImage('assets/pic${index + 1}.png'),
    );
  }

InfiniteCards(
            itemBuilder: _renderItem,
            itemCount: 5,
            controller: _controller,
            animType: _animType,
          )
```

### 调用Controller方法
```dart
  _controller.previous();
  _controller.next();
  _controller.reset();
```

### 自定义动效
#### 默认
默认动效无需任何配置

#### 自定义
```dart
InfiniteCards(
            ...
            transformToFront: yourCustomTransformToFront,
            transformToBack: yourCustomTransformToBack,
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
