import 'package:adaptive/global/styling.dart';
import 'package:adaptive/widgets/scroll_view_with_scrollbars.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';

/// Shows 3 types of layout, a vertical for narrow screens, wide for wide screens, and a mixed mode.

enum ReflowMode { vertical, horizontal, mixed }

class AdaptiveReflow extends StatelessWidget {
  const AdaptiveReflow({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      /// Decide which mode to show in
      ReflowMode reflowMode = ReflowMode.mixed;
      if (constraints.maxWidth < 800) {
        reflowMode = ReflowMode.vertical;
      } else if (constraints.maxHeight < 800) {
        reflowMode = ReflowMode.horizontal;
      }
      // In mixed mode, use a mix of Colum and Row
      if (reflowMode == ReflowMode.mixed) {
        return Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: contentPanel1()),
                  Expanded(child: contentPanel2()),
                ],
              ),
            ),
            Expanded(child: contentPanel3()),
          ],
        );
      }
      // In vertical or horizontal mode, use a ExpandedScrollingFlex with the same set of children
      else {
        Axis direction = reflowMode == ReflowMode.horizontal ? Axis.horizontal : Axis.vertical;
        return ExpandedScrollingFlex(
            scrollViewBuilder: (axis, child) => ScrollViewWithScrollbars(axis: axis, child: child),
            direction: direction,
            children: [
              contentPanel1(),
              contentPanel2(),
              contentPanel3(),
            ].map((c) => Expanded(child: c)).toList());
      }
    });
  }
}

/// For demo purposes, simulate 3 different content areas
Widget contentPanel1() => const ContentPanel("Panel 1");
Widget contentPanel2() => const ContentPanel("Panel 2");
Widget contentPanel3() => const ContentPanel("Panel 3");

class ContentPanel extends StatelessWidget {
  const ContentPanel(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context) {
    VisualDensity density = Theme.of(context).visualDensity;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 300, minWidth: 300),
      child: Padding(
        padding: EdgeInsets.all(Insets.large + density.vertical * 6),
        child: Container(
          alignment: Alignment.center,
          color: Colors.purple.shade100,
          child: Text(label),
        ),
      ),
    );
  }
}
