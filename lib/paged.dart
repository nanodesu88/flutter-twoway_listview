import 'package:flutter/widgets.dart';
import 'package:twoway_listview/base.dart';

typedef PageLoader<T> = Future<List<T>> Function(int page);
typedef PageLoaderPlaceholder = Widget Function(BuildContext context, int page);
typedef RowBuilder<T> = Widget Function(BuildContext context, T row);

class TwoWayListViewPaged<T> extends StatefulWidget {
  final PageLoader<T> loader;
  final PageLoaderPlaceholder placeholder;
  final RowBuilder<T> builder;
  final int perPage;
  final int page;

  TwoWayListViewPaged({
    @required this.loader,
    this.placeholder,
    @required this.builder,
    @required this.perPage,
    this.page = 1,
  })  : assert(loader != null),
        assert(builder != null),
        assert(perPage != null),
        assert(perPage > 0),
        assert(page != null),
        assert(page > 0);

  @override
  State<StatefulWidget> createState() => _TwoWayListViewPagedState(
      loader: loader,
      placeholder: placeholder,
      builder: builder,
      perPage: perPage,
      page: page);
}

class _TwoWayListViewPagedState<T> extends State<TwoWayListViewPaged<T>> {
  final PageLoader<T> loader;
  final PageLoaderPlaceholder placeholder;
  final RowBuilder<T> builder;
  final int perPage;
  final int page;

  List<T> rows = [];

  int min;
  int max;
  bool haveNext = true;

  _TwoWayListViewPagedState({
    @required this.loader,
    @required this.placeholder,
    @required this.builder,
    @required this.perPage,
    @required this.page,
  })  : min = page,
        max = page;

  @override
  Widget build(BuildContext context) {
    return TwoWayListView(
      builder: (BuildContext context, int index) {
        final diff = page - min;
        final center = perPage * diff;
        final newIndex = index + center;

        /*
        print({
          'index': index,
          'center': center,
          'newIndex': newIndex,
          'min': min,
          'max': max,
        });
        */

        if (index.isNegative) {
          // Страница не загружена
          if (newIndex.isNegative) {
            if (min <= 1) {
              return null;
            }

            // Границы загрузки страницы
            if (index + 1 == 0 || (index + 1) % perPage == 0) {
              _fill(min - 1);

              return placeholder != null ? placeholder(context, min - 1) : null;
            }

            return null;
          }
        }

        if (newIndex < rows.length) {
          return builder(context, rows[newIndex]);
        }

        // Грузим следующую
        if (newIndex == rows.length) {
          if (!haveNext) {
            return null;
          }

          _fill(max + 1);

          return placeholder != null ? placeholder(context, max + 1) : null;
        }

        return null;
      },
    );
  }

  Future<void> _fill(int p) async {
    final res = await loader(p);

    setState(() {
      if (p > page) {
        // Получено меньше чем было затребованно
        // Следующей страницы не существует
        if (res.length < perPage) {
          haveNext = false;
        }

        max = p;
        rows.addAll(res);
      } else {
        min = p;
        rows.insertAll(0, res);
      }

      // ready = true;
    });
  }
}
