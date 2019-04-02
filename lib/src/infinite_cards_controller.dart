import 'package:flutter/widgets.dart';

import 'anim_helper.dart';
import 'anim_transform.dart';
import 'infinite_card_view.dart';

class InfiniteCardsController {
  //widget item builder
  IndexedWidgetBuilder _itemBuilder;

  //item count
  int _itemCount;

  //switch anim duration
  Duration _animDuration;

  //true: switch animation while click on item, false: item not clickable
  bool _clickItemToSwitch;

  //anim transforms
  AnimTransform _transformToFront,
      _transformToBack,
      _transformCommon,
      _transformAdd,
      _transformRemove;

  //zIndex transforms
  ZIndexTransform _zIndexTransformCommon,
      _zIndexTransformToFront,
      _zIndexTransformToBack;

  //animation type
  AnimType _animType;

  //curve
  Curve _curve;

  //helper
  AnimHelper _animHelper;

  InfiniteCardsController({
    @required IndexedWidgetBuilder itemBuilder,
    @required int itemCount,
    Duration animDuration,
    bool clickItemToSwitch = true,
    AnimTransform transformToFront = DefaultToFrontTransform,
    AnimTransform transformToBack = DefaultToBackTransform,
    AnimTransform transformCommon = DefaultCommonTransform,
    AnimTransform transformAdd = DefaultAddTransform,
    AnimTransform transformRemove = DefaultRemoveTransform,
    ZIndexTransform zIndexTransformCommon = DefaultCommonZIndexTransform,
    ZIndexTransform zIndexTransformToFront = DefaultToFrontZIndexTransform,
    ZIndexTransform zIndexTransformToBack = DefaultCommonZIndexTransform,
    AnimType animType = AnimType.TO_FRONT,
    Curve curve = DefaultCurve,
  })  : _itemBuilder = itemBuilder,
        _itemCount = itemCount,
        _animDuration = animDuration,
        _clickItemToSwitch = clickItemToSwitch,
        _transformToFront = transformToFront,
        _transformToBack = transformToBack,
        _transformCommon = transformCommon,
        _transformAdd = transformAdd,
        _transformRemove = transformRemove,
        _zIndexTransformCommon = zIndexTransformCommon,
        _zIndexTransformToFront = zIndexTransformToFront,
        _zIndexTransformToBack = zIndexTransformToBack,
        _animType = animType,
        _curve = curve;

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
    //reset params while remove anim comes to an end
    _animHelper.animCallback = (AnimStatus status) {
      if (status == AnimStatus.RemoveEnd) {
        this._itemBuilder = itemBuilder ?? this._itemBuilder;
        this._itemCount = itemCount ?? this._itemCount;
        this._animDuration = animDuration ?? this._animDuration;
        this._clickItemToSwitch = clickItemToSwitch ?? this._clickItemToSwitch;
        this._transformToFront = transformToFront ?? this._transformToFront;
        this._transformToBack = transformToBack ?? this._transformToBack;
        this._transformCommon = transformCommon ?? this._transformCommon;
        this._transformAdd = transformAdd ?? this._transformAdd;
        this._transformRemove = transformRemove ?? this._transformRemove;
        this._zIndexTransformCommon =
            zIndexTransformCommon ?? this._zIndexTransformCommon;
        this._zIndexTransformToFront =
            zIndexTransformToFront ?? this._zIndexTransformToFront;
        this._zIndexTransformToBack =
            zIndexTransformToBack ?? this._zIndexTransformToBack;
        this._animType = animType ?? this._animType;
        this._curve = curve ?? this._curve;
        if (forceReset) {
          _animHelper.resetWidgets();
        }
        _animHelper.animCallback = null;
      }
    };
    if (forceReset) {
      _animHelper.reset();
      return;
    }
    //direct set params
    _animHelper.animCallback(AnimStatus.RemoveEnd);
  }

  Curve get curve => _curve;

  AnimType get animType => _animType;

  get zIndexTransformToBack => _zIndexTransformToBack;

  get zIndexTransformToFront => _zIndexTransformToFront;

  ZIndexTransform get zIndexTransformCommon => _zIndexTransformCommon;

  get transformRemove => _transformRemove;

  get transformAdd => _transformAdd;

  get transformCommon => _transformCommon;

  get transformToBack => _transformToBack;

  AnimTransform get transformToFront => _transformToFront;

  bool get clickItemToSwitch => _clickItemToSwitch;

  Duration get animDuration => _animDuration;

  int get itemCount => _itemCount;

  IndexedWidgetBuilder get itemBuilder => _itemBuilder;

  set animHelper(AnimHelper value) {
    _animHelper = value;
  }
}
