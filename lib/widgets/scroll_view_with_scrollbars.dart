import 'package:flutter/material.dart';

class ScrollViewWithScrollbars extends StatefulWidget {
  const ScrollViewWithScrollbars({super.key, required this.child, this.axis = Axis.vertical});
  final Widget child;
  final Axis axis;
  @override
  State createState() => ScrollViewWithScrollbarsState();
}

class ScrollViewWithScrollbarsState extends State<ScrollViewWithScrollbars> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        scrollDirection: widget.axis,
        controller: _scrollController,
        child: widget.child,
      ),
    );
  }
}
