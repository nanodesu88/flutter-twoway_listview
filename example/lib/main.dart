import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:twoway_listview/twoway_listview.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  TabController _tabController;

  _MyAppState() {
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          bottom: TabBar(
            controller: _tabController,
            tabs: <Widget>[
              Text('basic, -20 25 limits'),
              Text('paged, 20 perpage, 117 rows, 3 page starts'),
            ],
          ),
        ),
        body: Center(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              TwoWayListView(
                builder: (BuildContext context, int index) {
                  if (index < -20 || index > 25) {
                    return null;
                  }

                  return _ListTile(child: Text('$index'));
                },
              ),
              TwoWayListViewPaged(
                page: 3,
                perPage: 20,
                loader: (int page) async {
                  developer.log('[1] loading $page');

                  return Future.delayed(Duration(seconds: 2), () {
                    int count = 20;

                    if (page == 6) {
                      count = 17;
                    }

                    if (page > 6) {
                      count = 0;
                    }

                    return List.generate(count, (int index) {
                      return (page - 1) * 20 + (index + 1);
                    });
                  });
                },
                placeholder: (BuildContext context, int page) {
                  return Column(
                    children: <Widget>[
                      Text('loading $page page'),
                      CircularProgressIndicator(),
                    ],
                  );
                },
                builder: (BuildContext context, int row) {
                  return _ListTile(child: Text('$row'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  final Widget child;

  _ListTile({@required this.child});

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.red),
        ),
      ),
      padding: EdgeInsets.only(top: 10, bottom: 10),
      alignment: AlignmentDirectional.center,
      child: child,
    );
  }
}
