import 'package:flutter/material.dart';

typedef Future<Iterable<T>> DataFunction<T>(int offset, int length);

class ScrollingListView<T> extends StatefulWidget {
  final DataFunction<T> dataFunction;
  final int length;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final Widget Function(BuildContext context) noContentBuilder;
  final double maxExtent;
  final List<T> initialItems;

  ScrollingListView(
    {
      @required this.dataFunction,
      @required this.length,
      @required this.itemBuilder,
      @required this.noContentBuilder,
      this.maxExtent = 500,
      this.initialItems,
      Key key
    }
  ) : super(key: key);

  @override
  ScrollingListViewState<T> createState() 
    => ScrollingListViewState<T>(initialItems: initialItems);
}

class ScrollingListViewState<T> extends State<ScrollingListView> {
  final List<T> items;
  ScrollController controller;
  int offset = 0;
  bool endReached = false;
  ScrollingListViewState({List<T> initialItems}) 
    : this.items = initialItems ?? List<T>()
    , this.offset = initialItems == null ? 0 : initialItems.length;

  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
    _fetchItems();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return widget.noContentBuilder(context);
    }

    return ListView.builder(
      controller: controller,
      itemCount: items.length,
      itemBuilder: (context, index) => widget.itemBuilder(context, items[index]),
    );
  }

  void _scrollListener() {
    if (!endReached && controller.position.extentAfter < widget.maxExtent) {
      _fetchItems();
    }
  }

  Future<void> _fetchItems() async {
    Iterable<T> newItems = await widget.dataFunction(offset, widget.length);
    if (newItems == null) {
      endReached = true;
      return;
    }
    else if (newItems.length < widget.length) {
      endReached = true;
    }

    if (!mounted) return;

    setState(() {
      offset += widget.length;
      items.addAll(newItems);
    });
  }
}