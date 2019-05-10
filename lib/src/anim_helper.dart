import 'package:flutter_web/animation.dart';
import 'package:flutter_web/widgets.dart';

import 'card_item.dart';
import 'infinite_card_view.dart';
import 'infinite_cards_controller.dart';

const int ANIM_DURATION = 1000,
    ANIM_ADD_REMOVE_DELAY = 200,
    ANIM_ADD_REMOVE_DURATION = 500;

enum AnimStatus { CardStart, CardEnd, AddStart, AddEnd, RemoveStart, RemoveEnd }

typedef AnimCallback = void Function(AnimStatus status);

class AnimHelper {
  final InfiniteCardsController controller;
  final VoidCallback listenerForSetState;

  //animations for switch
  AnimationController _animationController;
  Animation<double> _animation;

  //animations for add and remove
  List<AnimationController> _animationControllerAddRemoveList = new List();
  List<Animation<double>> _animationAddRemoveList = new List();

  //items
  List<CardItem> _cardList = new List();

  //item moves to back, item moves to front
  CardItem _cardToBack, _cardToFront;

  //the position of item moves to back, the position of item moves to front
  int _positionToBack, _positionToFront;

  //is add remove anim running, is switch anim running
  bool _isAddRemoveAnim = false, _isSwitchAnim = false, _isAddAnim = true;

  AnimCallback animCallback;
  TickerProvider _tickerProvider;
  BuildContext _context;

  AnimHelper({@required this.controller, @required this.listenerForSetState});

  void init(TickerProvider tickerProvider, BuildContext context) {
    _tickerProvider = tickerProvider;
    _context = context;
    _initAnimation();
    _initCards();
  }

  //switch to previous card
  void previous() {
    if (isAnim()) {
      return;
    }
    //not support for TO_END type
    if (controller.animType == AnimType.TO_END) {
      return;
    }
    _cardAnim(controller.itemCount - 1, _cardList[controller.itemCount - 1]);
  }

  //switch to next card
  void next() {
    if (isAnim()) {
      return;
    }
    //only support for TO_END type
    if (controller.animType != AnimType.TO_END) {
      return;
    }
    _cardAnim(0, _cardList[0]);
  }

  //select specific index card
  void anim(int index) {
    if (isAnim()) {
      return;
    }
    if (controller.animType == AnimType.TO_END) {
      return;
    }
    _cardAnim(index, _cardList[index]);
  }

  //reset cards
  void reset() {
    if (isAnim()) {
      return;
    }
    _removeCards();
  }

  //reset card widgets
  void resetWidgets() {
    _initAddRemoveAnimation();
    _initWidgets();
  }

  //init cards
  void _initCards() {
    _initWidgets();
    _addCards();
  }

  //init widgets
  void _initWidgets() {
    _cardList = List();
    for (int i = 0; i < controller.itemCount; i++) {
      Widget item = controller.itemBuilder(_context, i);
      item = _wrapItem(item, i);
      _cardList.add(CardItem(0, i, item));
    }
  }

  //init animation
  void _initAnimation() {
    _animationController = AnimationController(
        vsync: _tickerProvider,
        duration: controller.animDuration ??
            const Duration(milliseconds: ANIM_DURATION));
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
    _initAddRemoveAnimation();
  }

  //init add remove animation
  void _initAddRemoveAnimation() {
    _animationControllerAddRemoveList = new List();
    _animationAddRemoveList = new List();
    for (int i = 0; i < controller.itemCount; i++) {
      AnimationController animationController = AnimationController(
          vsync: _tickerProvider,
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
      if (i == controller.itemCount - 1) {
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

  //add cards
  void _addCards() {
    _isAddAnim = true;
    if (animCallback != null) {
      animCallback(AnimStatus.AddStart);
    }
    _addRemoveAnim();
  }

  //remove cards
  void _removeCards() {
    _isAddAnim = false;
    if (animCallback != null) {
      animCallback(AnimStatus.RemoveStart);
    }
    _addRemoveAnim();
  }

  //add remove animation
  void _addRemoveAnim() {
    _isAddRemoveAnim = true;
    _isSwitchAnim = false;
    for (int i = 0; i < controller.itemCount; i++) {
      Future.delayed(Duration(milliseconds: ANIM_ADD_REMOVE_DELAY * i), () {
        _animationControllerAddRemoveList[i].forward(from: 0.0);
      });
    }
  }

  //wrap item with GestureDetector if clickItemToSwitch is true
  Widget _wrapItem(Widget item, int index) {
    Widget card = Center(
      child: item,
    );
    //type TO_END not support for switch anim
    if (controller.clickItemToSwitch &&
        controller.animType != AnimType.TO_END) {
      return GestureDetector(
        onTap: () {
          _onItemTap(index);
        },
        child: card,
      );
    }
    return card;
  }

  //tap to switch
  void _onItemTap(int index) {
    //type TO_END is not support
    if (controller.animType == AnimType.TO_END) {
      return;
    }
    for (int i = 0; i < controller.itemCount; i++) {
      CardItem card = _cardList[i];
      if (card.adapterIndex == index) {
        if (i != 0) {
          _cardAnim(i, card);
        }
        return;
      }
    }
  }

  //animation for specific card
  void _cardAnim(int index, CardItem card) {
    if (isAnim()) {
      return;
    }
    if (animCallback != null) {
      animCallback(AnimStatus.CardStart);
    }
    switch (controller.animType) {
      /**
     * for SWITCH type, make the selected card to front, and make the first
     * card to the selected position
     */
      case AnimType.SWITCH:
        _cardToFront = card;
        _cardToBack = _cardList[0];
        _positionToBack = 0;
        _positionToFront = index;
        break;
      //for TO_FRONT type, just make the select card to first
      case AnimType.TO_FRONT:
        _cardToFront = card;
        _positionToFront = index;
        _cardToBack = null;
        _positionToBack = 0;
        break;
      //for TO_END type, just make the first to end
      case AnimType.TO_END:
        _cardToFront = null;
        _positionToFront = controller.itemCount - 1;
        _cardToBack = card;
        _positionToBack = index;
        break;
    }
    _animationController.forward(from: 0.0);
  }

  //switch animation end
  void _animEnd() {
    switch (controller.animType) {
      // for SWITCH type, switch the position of the selected card and the first
      case AnimType.SWITCH:
        _cardList.removeAt(_positionToFront);
        _cardList.removeAt(0);
        _cardList.insert(0, _cardToFront);
        _cardList.insert(_positionToFront, _cardToBack);
        break;
      // for TO_FRONT type, move the selected card to first
      case AnimType.TO_FRONT:
        _cardList.removeAt(_positionToFront);
        _cardList.insert(0, _cardToFront);
        break;
      // for TO_END type, move the first card to end
      case AnimType.TO_END:
        _cardList.removeAt(0);
        _cardList.add(_cardToBack);
        break;
    }
    if (animCallback != null) {
      animCallback(AnimStatus.CardEnd);
    }
  }

  //add remove animation end
  void _addRemoveAnimEnd() {
    for (AnimationController controller in _animationControllerAddRemoveList) {
      controller.reset();
    }
    if (animCallback != null) {
      animCallback(_isAddAnim ? AnimStatus.AddEnd : AnimStatus.RemoveEnd);
    }
    //if remove animation is end, start add card animation
    if (!_isAddAnim) {
      _cardList.sort((card1, card2) {
        return card1.adapterIndex > card2.adapterIndex ? 1 : -1;
      });
      _isAddRemoveAnim = true;
      _addCards();
    }
  }

  //is animation running
  bool isAnim() {
    return _isSwitchAnim || _isAddRemoveAnim;
  }

  // get card widgets
  List<Widget> getCardList(double width, double height) {
    for (int i = 0; i < controller.itemCount; i++) {
      if (_isAddRemoveAnim) {
        //perform add remove anim
        if (_isAddAnim) {
          _addTransform(i, width, height);
        } else {
          _removeTransform(i, width, height);
        }
      } else if (_isSwitchAnim) {
        //perform switch anim
        _switchTransform(width, height, i);
      } else {
        //perform common anim
        _commonTransform(width, height, i, i);
      }
    }
    //render card widgets in the order of zIndex
    List<CardItem> copy = List.from(_cardList);
    copy.sort((card1, card2) {
      return card1.zIndex < card2.zIndex ? 1 : -1;
    });
    return copy.map((card) {
      return card.transformWidget;
    }).toList();
  }

  //add anim transform
  void _addTransform(int position, double width, double height) {
    CardItem cardItem = _cardList[position];
    Animation animation = _animationAddRemoveList[position];
    controller.zIndexTransformCommon(_cardList[position], animation.value,
        _getCurveValue(animation.value), width, height, position + 1, position);
    cardItem.transformWidget = controller.transformAdd(
        cardItem.widget,
        animation.value,
        _getCurveValue(animation.value),
        width,
        height,
        position + 1,
        position);
  }

  // remove anim transform
  void _removeTransform(int position, double width, double height) {
    CardItem cardItem = _cardList[position];
    Animation animation = _animationAddRemoveList[position];
    controller.zIndexTransformCommon(_cardList[position], animation.value,
        _getCurveValue(animation.value), width, height, position, position);
    cardItem.transformWidget = controller.transformRemove(
        cardItem.widget,
        animation.value,
        _getCurveValue(animation.value),
        width,
        height,
        position,
        position);
  }

  //common transform
  void _commonTransform(
      double width, double height, int fromPosition, int toPosition) {
    CardItem cardItem = _cardList[fromPosition];
    controller.zIndexTransformCommon(
        cardItem,
        _animation.value,
        _getCurveValue(_animation.value),
        width,
        height,
        fromPosition,
        toPosition);
    cardItem.transformWidget = controller.transformCommon(
        cardItem.widget,
        _animation.value,
        _getCurveValue(_animation.value),
        width,
        height,
        fromPosition,
        toPosition);
  }

  //switch transform
  void _switchTransform(double width, double height, int position) {
    CardItem cardItem = _cardList[position];
    if (cardItem == _cardToBack) {
      _toBackTransform(width, height, position, _positionToFront);
      return;
    } else if (cardItem == _cardToFront) {
      _toFrontTransform(width, height, position, _positionToBack);
      return;
    }
    switch (controller.animType) {
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

  //to front transform
  void _toFrontTransform(
      double width, double height, int fromPosition, int toPosition) {
    CardItem cardItem = _cardList[fromPosition];
    controller.zIndexTransformToFront(
        cardItem,
        _animation.value,
        _getCurveValue(_animation.value),
        width,
        height,
        fromPosition,
        toPosition);
    cardItem.transformWidget = controller.transformToFront(
        cardItem.widget,
        _animation.value,
        _getCurveValue(_animation.value),
        width,
        height,
        fromPosition,
        toPosition);
  }

  //to back transform
  void _toBackTransform(
      double width, double height, int fromPosition, int toPosition) {
    CardItem cardItem = _cardList[fromPosition];
    controller.zIndexTransformToBack(
        cardItem,
        _animation.value,
        _getCurveValue(_animation.value),
        width,
        height,
        fromPosition,
        toPosition);
    cardItem.transformWidget = controller.transformToBack(
        cardItem.widget,
        _animation.value,
        _getCurveValue(_animation.value),
        width,
        height,
        fromPosition,
        toPosition);
  }

  //get value transformed by curve
  double _getCurveValue(double fraction) {
    return controller.curve == null
        ? fraction
        : controller.curve.transform(fraction);
  }
}
