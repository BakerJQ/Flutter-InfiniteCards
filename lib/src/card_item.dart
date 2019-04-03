import 'package:flutter/widgets.dart';

class CardItem {
  double zIndex;
  final int adapterIndex;
  final Widget widget;
  Widget transformWidget;

  CardItem(this.zIndex, this.adapterIndex, this.widget);

  @override
  int get hashCode => adapterIndex;

  @override
  bool operator ==(other) {
    if (!(other is CardItem)) {
      return false;
    }
    return other.adapterIndex == adapterIndex;
  }
}
