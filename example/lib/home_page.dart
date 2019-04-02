import 'package:flutter/material.dart';
import 'package:infinite_cards/infinite_cards.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  InfiniteCardsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = InfiniteCardsController(
      itemBuilder: _renderItem,
      itemCount: 5,
      animType: AnimType.SWITCH,
    );
  }

  Widget _renderItem(BuildContext context, int index) {
    return Image(
      image: AssetImage('assets/pic${index + 1}.png'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("InfiniteCards"),
      ),
      body: Column(
        children: <Widget>[
          InfiniteCards(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 1.3,
            controller: _controller,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  _controller.previous();
                },
                child: Text("Pre"),
              ),
              RaisedButton(
                onPressed: () {
                  _controller.reset(forceReset: true);
                },
                child: Text("Reset"),
              ),
              RaisedButton(
                onPressed: () {
                  _controller.next();
                },
                child: Text("Next"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
