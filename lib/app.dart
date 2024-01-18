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
        label: "Grid",
        isSelected: index == 0),
    SelectedPageButton(
        onPressed: () => changePage(1),
        label: "Data Table",
        isSelected: index == 1),
    SelectedPageButton(
        onPressed: () => changePage(2),
        label: "Reflow",
        isSelected: index == 2),
    SelectedPageButton(
        onPressed: () => changePage(3),
        label: "Focus",
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
        child: Material(
          child: Column(
            children: [
              const AppTitleBar(),
              Expanded(
                child: Focus(
                  autofocus: true,
                  child: Scaffold(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    key: _scaffoldKey,
                    drawer: useTabs
                        ? const SideMenu(showPageButtons: false)
                        : null,
                    appBar: useTabs
                        ? AppBar(backgroundColor: Theme.of(context).scaffoldBackgroundColor)
                        : null,
                    body: Stack(children: [
                      // Vertical layout with Tab controller and drawer
                      if (useTabs) ...[
                        const Column(
                          children: [
                            Expanded(child: PageStack()),
                            TabMenu(),
                          ],
                        )
                      ]
                      // Horizontal layout with desktop style side menu
                      else ...[
                        const Row(
                          children: [
                            SideMenu(),
                            Expanded(child: PageStack()),
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

class PageStack extends StatelessWidget {
  const PageStack({super.key});

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

class SideMenu extends StatelessWidget {
  const SideMenu({super.key, this.showPageButtons = true});

  final bool showPageButtons;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
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
                  width: 1, height: double.infinity, color: Theme.of(context).scaffoldBackgroundColor)),
        ],
      ),
    );
  }
}

class TabMenu extends StatelessWidget {
  const TabMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap all the main menu buttons in Expanded() so they fill up the screen horizontally
    List<Expanded> tabButtons = getMainMenuChildren(context)
        .map((btn) => Expanded(child: btn))
        .toList();
    return Column(
      children: [
        // Top Divider
        Container(width: double.infinity, height: 1, color: Theme.of(context).scaffoldBackgroundColor),
        // Tab buttons
        Row(
            children: tabButtons
        ),
      ],
    );
  }
}
