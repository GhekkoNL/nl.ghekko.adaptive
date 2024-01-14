import 'package:adaptive/pages/adaptive_table.dart';
import 'package:adaptive/pages/adaptive_grid.dart';
import 'package:adaptive/pages/adaptiv_reflow.dart';
import 'package:adaptive/pages/focus_selector.dart';
import 'package:adaptive/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'global/device_size.dart';
import 'global/styling.dart';
import 'global/targeted_actions.dart';
import 'model/app_model.dart';
import 'widgets/app_title_bar.dart';

List<Widget> getMainMenuChildren(BuildContext context) {
  // Define a method to change pages in the AppModel
  void changePage(int value) => context.read<AppModel>().selectedIndex = value;
  int index = context.select((AppModel m) => m.selectedIndex);
  return [
    SelectedPageButton(
        onPressed: () => changePage(0),
        label: "Adaptive Grid",
        isSelected: index == 0),
    SelectedPageButton(
        onPressed: () => changePage(1),
        label: "Adaptive Data Table",
        isSelected: index == 1),
    SelectedPageButton(
        onPressed: () => changePage(2),
        label: "Adaptive Reflow",
        isSelected: index == 2),
    SelectedPageButton(
        onPressed: () => changePage(3),
        label: "Focus Examples",
        isSelected: index == 3),
  ];
}

// Uses a tab navigation + drawer,  or a side-menu that combines both
class App extends StatefulWidget {
  const App({super.key});

  @override
  State createState() => AppState();
}

class AppState extends State<App> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    bool useTabs = MediaQuery.of(context).size.width < FormFactor.tablet;
    return TargetedActionScope(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.keyA, LogicalKeyboardKey.control):
            SelectAllIntent(),
        LogicalKeySet(LogicalKeyboardKey.keyS, LogicalKeyboardKey.control):
            SelectNoneIntent(),
        LogicalKeySet(LogicalKeyboardKey.delete): DeleteIntent(),
      },
      child: SizedBox(
        //color: Colors.white,
        child: Material(
          child: Column(
            children: [
              const AppTitleBar(),
              Expanded(
                child: Focus(
                  autofocus: true,
                  child: Scaffold(
                    key: _scaffoldKey,
                    drawer: useTabs
                        ? const _SideMenu(showPageButtons: false)
                        : null,
                    appBar: useTabs
                        ? AppBar(backgroundColor: Colors.blue.shade300)
                        : null,
                    body: Stack(children: [
                      // Vertical layout with Tab controller and drawer
                      if (useTabs) ...[
                        Column(
                          children: [
                            Expanded(child: _PageStack()),
                            _TabMenu(),
                          ],
                        )
                      ]
                      // Horizontal layout with desktop style side menu
                      else ...[
                        Row(
                          children: [
                            const _SideMenu(),
                            Expanded(child: _PageStack()),
                          ],
                        ),
                      ],
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int index = context.select((AppModel model) => model.selectedIndex);
    Widget? page;
    if (index == 0) page = const AdaptiveGrid();
    if (index == 1) page = AdaptiveDataTable();
    if (index == 2) page = const AdaptiveReflow();
    if (index == 3) page = const FocusSelector();
    return FocusTraversalGroup(child: page ?? Container());
  }
}

class _SideMenu extends StatelessWidget {
  const _SideMenu({this.showPageButtons = true});

  final bool showPageButtons;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 250,
      child: Stack(
        children: [
          // Buttons
          Column(children: [
            SizedBox(height: Insets.extraLarge),
            if (showPageButtons) ...getMainMenuChildren(context),
            SizedBox(height: Insets.extraLarge),
            const SecondaryMenuButton(label: "Submenu Item 1"),
            const SecondaryMenuButton(label: "Submenu Item 2"),
            const SecondaryMenuButton(label: "Submenu Item 3"),
            const Spacer(),
            OutlinedButton(onPressed: () {}, child: const Text("Button")),
            SizedBox(height: Insets.large),
          ]),
          // Divider
          Align(
              alignment: Alignment.centerRight,
              child: Container(
                  width: 1, height: double.infinity, color: Colors.blue)),
        ],
      ),
    );
  }
}

class _TabMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Wrap all the main menu buttons in Expanded() so they fill up the screen horizontally
    List<Expanded> tabButtons = getMainMenuChildren(context)
        .map((btn) => Expanded(child: btn))
        .toList();
    return Column(
      children: [
        // Top Divider
        Container(width: double.infinity, height: 1, color: Colors.blue),
        // Tab buttons
        Row(children: tabButtons),
      ],
    );
  }
}
