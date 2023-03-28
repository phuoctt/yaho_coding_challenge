import 'package:flutter/material.dart';

typedef FutureCallBack = Future<bool> Function();

class LoadMore extends StatefulWidget {
  final Widget? child;
  final bool isFinish;
  final bool isBehindFinish;

  final FutureCallBack? onLoadMore;

  final FutureCallBack? onLoadBehind;

  const LoadMore({
    Key? key,
    this.child,
    this.onLoadMore,
    this.isFinish = false,
    this.isBehindFinish = true,
    this.onLoadBehind,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoadState();
}

class _LoadState extends State<LoadMore> {
  Widget? get child => widget.child;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (child is ListView) {
      return _buildListView(child as ListView);
    }
    if (child is GridView) {
      return _buildGridView(child as GridView);
    }


    return child ?? const SizedBox.shrink();
  }

  Widget _buildListView(ListView listView) {
    var delegate = listView.childrenDelegate;

    if (delegate is SliverChildBuilderDelegate) {
      SliverChildBuilderDelegate delegate =
          listView.childrenDelegate as SliverChildBuilderDelegate;

      var viewCount = widget.isFinish
          ? delegate.estimatedChildCount
          : delegate.estimatedChildCount! + 1;

      IndexedWidgetBuilder builder = (context, index) {
        if (index == viewCount! - 1 && !widget.isFinish) {
          return _buildLoadMoreView();
        }
        return delegate.builder(context, index) ?? Container();
      };

      return ListView.builder(
        itemBuilder: builder,
        addAutomaticKeepAlives: delegate.addAutomaticKeepAlives,
        addRepaintBoundaries: delegate.addRepaintBoundaries,
        addSemanticIndexes: delegate.addSemanticIndexes,
        dragStartBehavior: listView.dragStartBehavior,
        semanticChildCount: listView.semanticChildCount,
        itemCount: viewCount,
        cacheExtent: listView.cacheExtent,
        itemExtent: listView.itemExtent,
        key: listView.key,
        padding: listView.padding,
        physics: listView.physics,
        primary: false,
        controller: listView.controller,
        reverse: listView.reverse,
        scrollDirection: listView.scrollDirection,
        shrinkWrap: listView.shrinkWrap,
      );
    }
    return listView;
  }

  LoadMoreStatus status = LoadMoreStatus.idle;

  _buildLoadMoreView() {
    return NotificationListener<_BuildNotify>(
      onNotification: _onLoadMoreBuild,
      child: _LoadMoreView(status: status),
    );
  }

  _buildLoadMoreBehindView() {
    return NotificationListener<_BuildNotify>(
      onNotification: _onLoadMoreBehindBuild,
      child: _LoadMoreView(status: status),
    );
  }

  bool _onLoadMoreBehindBuild(_BuildNotify notification) {
    if (status == LoadMoreStatus.loading) {
      return false;
    }
    if (status == LoadMoreStatus.fail) {
      return false;
    }
    if (status == LoadMoreStatus.idle) {
      loadMoreBehind();
    }
    return false;
  }

  bool _onLoadMoreBuild(_BuildNotify notification) {
    if (status == LoadMoreStatus.loading) {
      return false;
    }
    if (status == LoadMoreStatus.fail) {
      return false;
    }
    if (status == LoadMoreStatus.idle) {
      loadMore();
    }
    return false;
  }

  void _updateStatus(LoadMoreStatus status) {
    this.status = status;
  }

  void loadMoreBehind() {
    _updateStatus(LoadMoreStatus.loading);
    if (widget.onLoadBehind != null) {
      widget.onLoadBehind!().then((v) {
        if (v == true) {
          _updateStatus(LoadMoreStatus.idle);
        } else {
          _updateStatus(LoadMoreStatus.fail);
        }
      });
    }
  }

  void loadMore() {
    _updateStatus(LoadMoreStatus.loading);
    if (widget.onLoadMore != null) {
      widget.onLoadMore!().then((v) {
        if (v == true) {
          _updateStatus(LoadMoreStatus.idle);
        } else {
          _updateStatus(LoadMoreStatus.fail);
        }
      });
    }
  }




  Widget _buildGridView(GridView gridView) {
    var delegate = gridView.childrenDelegate;
    if (delegate is SliverChildBuilderDelegate) {
      SliverChildBuilderDelegate delegate =
          gridView.childrenDelegate as SliverChildBuilderDelegate;

      var viewCount = widget.isFinish
          ? delegate.estimatedChildCount
          : delegate.estimatedChildCount! + 1;

      IndexedWidgetBuilder builder = (context, index) {
        if (index == viewCount! - 1 && !widget.isFinish) {
          return _buildLoadMoreView();
        }
        return delegate.builder(context, index) ?? Container();
      };

      return GridView.builder(
        itemBuilder: builder,
        controller: gridView.controller,
        addAutomaticKeepAlives: delegate.addAutomaticKeepAlives,
        addRepaintBoundaries: delegate.addRepaintBoundaries,
        addSemanticIndexes: delegate.addSemanticIndexes,
        dragStartBehavior: gridView.dragStartBehavior,
        semanticChildCount: gridView.semanticChildCount,
        itemCount: viewCount,
        cacheExtent: gridView.cacheExtent,
        key: gridView.key,
        padding: gridView.padding,
        physics: gridView.physics,
        primary: false,
        reverse: gridView.reverse,
        scrollDirection: gridView.scrollDirection,
        shrinkWrap: gridView.shrinkWrap,
        gridDelegate: gridView.gridDelegate,
      );
    }
    return gridView;
  }
}

class _LoadMoreView extends StatelessWidget {
  final LoadMoreStatus status;

  const _LoadMoreView({Key? key, this.status = LoadMoreStatus.idle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    notify(context);
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
          ),
          opacity: 1,
        ),
      ),
    );
  }

  void notify(BuildContext context) async {
    if (status == LoadMoreStatus.idle) {
      _BuildNotify().dispatch(context);
    }
  }
}

class _BuildNotify extends Notification {}

enum LoadMoreStatus {
  idle,
  loading,
  fail,
}
