import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class TwoWayListView extends StatelessWidget {
  final IndexedWidgetBuilder builder;

  TwoWayListView({@required this.builder}) : assert(builder != null);

  Widget build(BuildContext context) {
    Key forwardListKey = UniqueKey();

    final forwardList = SliverList(
      key: forwardListKey,
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return builder(context, index);
        },
      ),
    );

    final reverseList = SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return builder(context, -1 - index);
        },
      ),
    );

    return Scrollable(
      viewportBuilder: (BuildContext context, ViewportOffset position) {
        return Viewport(
          offset: position,
          center: forwardListKey,
          slivers: <Widget>[reverseList, forwardList],
        );
      },
    );
  }
}
