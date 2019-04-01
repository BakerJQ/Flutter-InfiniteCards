import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';

import 'anim_transform.dart';
import 'card_item.dart';
import 'infinite_card_view.dart';

const int ANIM_DURATION = 1000,
    ANIM_ADD_REMOVE_DELAY = 200,
    ANIM_ADD_REMOVE_DURATION = 500;

class AnimHelper {
  final AnimTransform transformToFront,
      transformToBack,
      transformCommon,
      transformAdd,
      transformRemove;
  final ZIndexTransform zIndexTransformCommon,
      zIndexTransformToFront,
      zIndexTransformToBack;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Duration animDuration;
  final bool clickItemToSwitch;
  final VoidCallback listenerForSetState;
  final AnimInterpolator interpolator;
  AnimType animType;

  AnimationController _animationController;
  Animation<double> _animation;
  List<AnimationController> _animationControllerAddRemoveList = new List();
  List<Animation<double>> _animationAddRemoveList = new List();
  List<CardItem> _cardList = new List();
  CardItem _cardToBack, _cardToFront;
  int _positionToBack, _positionToFront;
  bool _isAddRemoveAnim = false, _isSwitchAnim = false, _isAddAnim = true;

  AnimHelper({
    @required this.transformToFront,
    @required this.transformToBack,
    @required this.transformCommon,
    @required this.transformAdd,
    @required this.transformRemove,
    @required this.zIndexTransformCommon,
    @required this.zIndexTransformToFront,
    @required this.zIndexTransformToBack,
    @required this.itemCount,
    @required this.itemBuilder,
    this.animDuration,
    this.clickItemToSwitch = true,
    @required this.listenerForSetState,
    this.animType = AnimType.TO_FRONT,
    this.interpolator = DefaultInterpolator,
  });

  void init(TickerProvider tickerProvider, BuildContext context) {
    _initAnimation(tickerProvider);
    _initCards(context);
  }

  void previous() {
    if (isAnim()) {
      return;
    }
    if (animType == AnimType.TO_END) {
      animType = AnimType.TO_FRONT;
    }
    _cardAnim(itemCount - 1, _cardList[itemCount - 1]);
  }

  void next() {
    if (isAnim()) {
      return;
    }
    if (animType != AnimType.TO_END) {
      animType = AnimType.TO_END;
    }
    _cardAnim(0, _cardList[0]);
  }

  void anim(int index) {
    if (isAnim()) {
      return;
    }
    if (animType == AnimType.TO_END) {
      animType = AnimType.TO_FRONT;
    }
    _cardAnim(index, _cardList[index]);
  }

  void reset() {
    if (isAnim()) {
      return;
    }
    _removeCards();
  }

  void _initCards(BuildContext context) {
    _cardList = List();
    for (int i = 0; i < itemCount; i++) {
      Widget item = itemBuilder(context, i);
      item = _wrapItem(item, i);
      _cardList.add(CardItem(0, i, item));
    }
    _addCards();
  }

  void _initAnimation(TickerProvider tickerProvider) {
    _animationController = AnimationController(
        vsync: tickerProvider,
        duration: animDuration ?? const Duration(milliseconds: ANIM_DURATION));
    _animation = new Tween(begin: 0.0, end: 1.0).animate(_animationController);
    _animation.addListener(listenerForSetState);
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.forward ||
          status == AnimationStatus.reverse) {
        _isSwitchAnim = true;
      } else if (status == AnimationStatus.completed) {
        _animEnd();
        _isSwitchAnim = false;
      }
    });
    _initAddRemoveAnimation(tickerProvider);
  }

  void _initAddRemoveAnimation(TickerProvider tickerProvider) {
    for (int i = 0; i < itemCount; i++) {
      AnimationController animationController = AnimationController(
          vsync: tickerProvider,
          duration: const Duration(milliseconds: ANIM_ADD_REMOVE_DURATION));
      Animation<double> animation =
          new Tween(begin: 0.0, end: 1.0).animate(animationController);
      animation.addListener(listenerForSetState);
      animation.addStatusListener((status) {
        if (status == AnimationStatus.forward ||
            status == AnimationStatus.reverse) {
          _isAddRemoveAnim = true;
        }
      });
      if (i == itemCount - 1) {
        animation.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _isAddRemoveAnim = false;
            _addRemoveAnimEnd();
          }
        });
      }
      _animationControllerAddRemoveList.add(animationController);
      _animationAddRemoveList.add(animation);
    }
  }

  void _addCards() {
    _isAddAnim = true;
    _addRemoveAnim();
  }

  void _removeCards() {
    _isAddAnim = false;
    _addRemoveAnim();
  }

  void _addRemoveAnim() {
    _isAddRemoveAnim = true;
    _isSwitchAnim = false;
    for (int i = 0; i < itemCount; i++) {
      Future.delayed(Duration(milliseconds: ANIM_ADD_REMOVE_DELAY * i), () {
        _animationControllerAddRemoveList[i].forward(from: 0.0);
      });
    }
  }

  Widget _wrapItem(Widget item, int index) {
    Widget card = Center(
      child: item,
    );
    if (clickItemToSwitch && animType != AnimType.TO_END) {
      return GestureDetector(
        onTap: () {
          _onItemTap(index);
        },
        child: card,
      );
    }
    return card;
  }

  void _onItemTap(int index) {
    if (animType == AnimType.TO_END) {
      return;
    }
    for (int i = 0; i < itemCount; i++) {
      CardItem card = _cardList[i];
      if (card.adapterIndex == index) {
        if (i != 0) {
          _cardAnim(i, card);
        }
        return;
      }
    }
  }

  void _cardAnim(int index, CardItem card) {
    if (isAnim()) {
      return;
    }
    switch (animType) {
      case AnimType.SWITCH:
        _cardToFront = card;
        _cardToBack = _cardList[0];
        _positionToBack = 0;
        _positionToFront = index;
        break;
      case AnimType.TO_FRONT:
        _cardToFront = card;
        _positionToFront = index;
        _cardToBack = null;
        _positionToBack = 0;
        break;
      case AnimType.TO_END:
        _cardToFront = null;
        _positionToFront = itemCount - 1;
        _cardToBack = card;
        _positionToBack = index;
        break;
    }
    _animationController.forward(from: 0.0);
  }

  void _animEnd() {
    switch (animType) {
      case AnimType.SWITCH:
        _cardList.removeAt(_positionToFront);
        _cardList.removeAt(0);
        _cardList.insert(0, _cardToFront);
        _cardList.insert(_positionToFront, _cardToBack);
        break;
      case AnimType.TO_FRONT:
        _cardList.removeAt(_positionToFront);
        _cardList.insert(0, _cardToFront);
        break;
      case AnimType.TO_END:
        _cardList.removeAt(0);
        _cardList.add(_cardToBack);
        break;
    }
  }

  void _addRemoveAnimEnd() {
    for (AnimationController controller in _animationControllerAddRemoveList) {
      controller.reset();
    }
    if (!_isAddAnim) {
      _cardList.sort((card1, card2) {
        return card1.adapterIndex > card2.adapterIndex ? 1 : -1;
      });
      _isAddRemoveAnim = true;
      _addCards();
    }
  }

  bool isAnim() {
    return _isSwitchAnim || _isAddRemoveAnim;
  }

  List<Widget> getCardList(double width, double height) {
    for (int i = 0; i < itemCount; i++) {
      if (_isAddRemoveAnim) {
        if (_isAddAnim) {
          _addTransform(i, width, height);
        } else {
          _removeTransform(i, width, height);
        }
      } else if (_isSwitchAnim) {
        _switchTransform(width, height, i);
      } else {
        _commonTransform(width, height, i, i);
      }
    }
    List<CardItem> copy = List.from(_cardList);
    copy.sort((card1, card2) {
      return card1.zIndex < card2.zIndex ? 1 : -1;
    });
    return copy.map((card) {
      return card.transformWidget;
    }).toList();
  }

  void _addTransform(int position, double width, double height) {
    CardItem cardItem = _cardList[position];
    Animation animation = _animationAddRemoveList[position];
    zIndexTransformCommon(
        _cardList[position],
        animation.value,
        _getInterpolatorValue(animation.value),
        width,
        height,
        position + 1,
        position);
    cardItem.transformWidget = transformAdd(
        cardItem.widget,
        animation.value,
        _getInterpolatorValue(animation.value),
        width,
        height,
        position + 1,
        position);
  }

  void _removeTransform(int position, double width, double height) {
    CardItem cardItem = _cardList[position];
    Animation animation = _animationAddRemoveList[position];
    zIndexTransformCommon(
        _cardList[position],
        animation.value,
        _getInterpolatorValue(animation.value),
        width,
        height,
        position,
        position);
    cardItem.transformWidget = transformRemove(
        cardItem.widget,
        animation.value,
        _getInterpolatorValue(animation.value),
        width,
        height,
        position,
        position);
  }

  void _commonTransform(
      double width, double height, int fromPosition, int toPosition) {
    CardItem cardItem = _cardList[fromPosition];
    zIndexTransformCommon(
        cardItem,
        _animation.value,
        _getInterpolatorValue(_animation.value),
        width,
        height,
        fromPosition,
        toPosition);
    cardItem.transformWidget = transformCommon(
        cardItem.widget,
        _animation.value,
        _getInterpolatorValue(_animation.value),
        width,
        height,
        fromPosition,
        toPosition);
  }

  void _switchTransform(double width, double height, int position) {
    CardItem cardItem = _cardList[position];
    if (cardItem == _cardToBack) {
      _toBackTransform(width, height, position, _positionToFront);
      return;
    } else if (cardItem == _cardToFront) {
      _toFrontTransform(width, height, position, _positionToBack);
      return;
    }
    switch (animType) {
      case AnimType.SWITCH:
        break;
      case AnimType.TO_FRONT:
        if (position < _positionToFront) {
          _commonTransform(width, height, position, position + 1);
        }
        break;
      case AnimType.TO_END:
        if (position > _positionToBack) {
          _commonTransform(width, height, position, position - 1);
        }
        break;
    }
  }

  void _toFrontTransform(
      double width, double height, int fromPosition, int toPosition) {
    CardItem cardItem = _cardList[fromPosition];
    zIndexTransformToFront(
        cardItem,
        _animation.value,
        _getInterpolatorValue(_animation.value),
        width,
        height,
        fromPosition,
        toPosition);
    cardItem.transformWidget = transformToFront(
        cardItem.widget,
        _animation.value,
        _getInterpolatorValue(_animation.value),
        width,
        height,
        fromPosition,
        toPosition);
  }

  void _toBackTransform(
      double width, double height, int fromPosition, int toPosition) {
    CardItem cardItem = _cardList[fromPosition];
    zIndexTransformToBack(
        cardItem,
        _animation.value,
        _getInterpolatorValue(_animation.value),
        width,
        height,
        fromPosition,
        toPosition);
    cardItem.transformWidget = transformToBack(
        cardItem.widget,
        _animation.value,
        _getInterpolatorValue(_animation.value),
        width,
        height,
        fromPosition,
        toPosition);
  }

  double _getInterpolatorValue(double fraction) {
    return interpolator == null ? fraction : interpolator(fraction);
  }
}
