import 'package:flutter/widgets.dart';

import 'anim_helper.dart';
import 'anim_transform.dart';
import 'infinite_cards_controller.dart';

enum AnimType { TO_FRONT, SWITCH, TO_END }

class InfiniteCards extends StatefulWidget {
  final double width, height;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final Color background;
  final Duration animDuration;
  final bool clickItemToSwitch;
  final AnimTransform transformToFront,
      transformToBack,
      transformCommon,
      transformAdd,
      transformRemove;
  final ZIndexTransform zIndexTransformCommon,
      zIndexTransformToFront,
      zIndexTransformToBack;
  final AnimType animType;
  final InfiniteCardsController controller;
  final AnimInterpolator interpolator;

  InfiniteCards({
    this.width,
    this.height,
    @required this.itemBuilder,
    @required this.itemCount,
    this.background,
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
    this.controller,
    this.interpolator = DefaultInterpolator,
  });

  @override
  _InfiniteCardsState createState() => _InfiniteCardsState();
}

class _InfiniteCardsState extends State<InfiniteCards>
    with TickerProviderStateMixin {
  double _width, _height;
  Color _background;
  AnimHelper _helper;

  @override
  void initState() {
    super.initState();
    _background = widget.background ?? Color(0xffffffff);
    _helper = AnimHelper(
        itemCount: widget.itemCount,
        transformAdd: widget.transformAdd,
        transformCommon: widget.transformCommon,
        transformRemove: widget.transformRemove,
        transformToBack: widget.transformToBack,
        transformToFront: widget.transformToFront,
        zIndexTransformCommon: widget.zIndexTransformCommon,
        zIndexTransformToFront: widget.zIndexTransformToFront,
        zIndexTransformToBack: widget.zIndexTransformToBack,
        itemBuilder: widget.itemBuilder,
        animDuration: widget.animDuration,
        clickItemToSwitch: widget.clickItemToSwitch,
        animType: widget.animType,
        interpolator: widget.interpolator,
        listenerForSetState: () {
          setState(() {});
        });
    _helper.init(this, context);
    if (widget.controller != null) {
      widget.controller.setAnimHelper(_helper);
    }
  }

  @override
  Widget build(BuildContext context) {
    _width = widget.width ?? MediaQuery.of(context).size.width;
    _height = widget.height ?? MediaQuery.of(context).size.height;
    return Container(
      width: _width,
      height: _height,
      color: _background,
      child: Stack(
        children: _helper.getCardList(_width, _height),
      ),
    );
  }
}
