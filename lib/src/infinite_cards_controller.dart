import 'package:flutter/widgets.dart';

import 'anim_helper.dart';
import 'anim_transform.dart';
import 'infinite_card_view.dart';

class InfiniteCardsController {
  //widget item builder
  IndexedWidgetBuilder itemBuilder;
  //item count
  int itemCount;
  //switch anim duration
  Duration animDuration;
  //true: switch animation while click on item, false: item not clickable
  bool clickItemToSwitch;
  //anim transforms
  AnimTransform transformToFront,
      transformToBack,
      transformCommon,
      transformAdd,
      transformRemove;
  //zIndex transforms
  ZIndexTransform zIndexTransformCommon,
      zIndexTransformToFront,
      zIndexTransformToBack;
  //animation type
  AnimType animType;
  //curve
  Curve curve;
  //helper
  AnimHelper _animHelper;

  InfiniteCardsController({
    @required this.itemBuilder,
    @required this.itemCount,
    this.animDuration,
    this.clickItemToSwitch = true,
    this.transformToFront = DefaultToFrontTransform,
    this.transformToBack = DefaultToBackTransform,
    this.transformCommon = DefaultCommonTransform,
    this.transformAdd = DefaultAddTransform,
    this.transformRemove = DefaultRemoveTransform,
    this.zIndexTransformCommon = DefaultCommonZIndexTransform,
    this.zIndexTransformToFront = DefaultToFrontZIndexTransform,
    this.zIndexTransformToBack = DefaultCommonZIndexTransform,
    this.animType = AnimType.TO_FRONT,
    this.curve = DefaultCurve,
  });

  void setAnimHelper(AnimHelper helper) {
    _animHelper = helper;
  }

  void previous() {
    _animHelper.previous();
  }

  void next() {
    _animHelper.next();
  }

  void anim(int index) {
    _animHelper.anim(index);
  }

  //reset params
  void reset({
    IndexedWidgetBuilder itemBuilder,
    int itemCount,
    Duration animDuration,
    bool clickItemToSwitch,
    AnimTransform transformToFront,
    AnimTransform transformToBack,
    AnimTransform transformCommon,
    AnimTransform transformAdd,
    AnimTransform transformRemove,
    ZIndexTransform zIndexTransformCommon,
    ZIndexTransform zIndexTransformToFront,
    ZIndexTransform zIndexTransformToBack,
    AnimType animType,
    Curve curve,
    bool forceReset = false,
  }) {
    if (_animHelper.isAnim()) {
      return;
    }
    //if item is changed, force reset
    if (itemBuilder != null || itemCount != null) {
      forceReset = true;
    }
    if (forceReset) {
      //reset params while remove anim comes to an end
      _animHelper.animCallback = (AnimStatus status) {
        if (status == AnimStatus.RemoveEnd) {
          this.itemBuilder = itemBuilder ?? this.itemBuilder;
          this.itemCount = itemCount ?? this.itemCount;
          this.animDuration = animDuration ?? this.animDuration;
          this.clickItemToSwitch = clickItemToSwitch ?? this.clickItemToSwitch;
          this.transformToFront = transformToFront ?? this.transformToFront;
          this.transformToBack = transformToBack ?? this.transformToBack;
          this.transformCommon = transformCommon ?? this.transformCommon;
          this.transformAdd = transformAdd ?? this.transformAdd;
          this.transformRemove = transformRemove ?? this.transformRemove;
          this.zIndexTransformCommon =
              zIndexTransformCommon ?? this.zIndexTransformCommon;
          this.zIndexTransformToFront =
              zIndexTransformToFront ?? this.zIndexTransformToFront;
          this.zIndexTransformToBack =
              zIndexTransformToBack ?? this.zIndexTransformToBack;
          this.animType = animType ?? this.animType;
          this.curve = curve ?? this.curve;
          _animHelper.resetWidgets();
          _animHelper.animCallback = null;
        }
      };
      _animHelper.reset();
      return;
    }
    this.itemBuilder = itemBuilder ?? this.itemBuilder;
    this.itemCount = itemCount ?? this.itemCount;
    this.animDuration = animDuration ?? this.animDuration;
    this.clickItemToSwitch = clickItemToSwitch ?? this.clickItemToSwitch;
    this.transformToFront = transformToFront ?? this.transformToFront;
    this.transformToBack = transformToBack ?? this.transformToBack;
    this.transformCommon = transformCommon ?? this.transformCommon;
    this.transformAdd = transformAdd ?? this.transformAdd;
    this.transformRemove = transformRemove ?? this.transformRemove;
    this.zIndexTransformCommon =
        zIndexTransformCommon ?? this.zIndexTransformCommon;
    this.zIndexTransformToFront =
        zIndexTransformToFront ?? this.zIndexTransformToFront;
    this.zIndexTransformToBack =
        zIndexTransformToBack ?? this.zIndexTransformToBack;
    this.animType = animType ?? this.animType;
    this.curve = curve ?? this.curve;
  }
}
