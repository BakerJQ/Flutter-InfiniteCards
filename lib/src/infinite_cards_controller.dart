import 'anim_helper.dart';
import 'infinite_card_view.dart';

class InfiniteCardsController {
  AnimHelper _animHelper;

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

  void reset() {
    _animHelper.reset();
  }

  void setAnimType(AnimType animType) {
    if (_animHelper.isAnim()) {
      return;
    }
    _animHelper.animType = animType;
  }
}
