import 'package:adaptive/app.dart';
import 'package:adaptive/theme/color_schemes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/app_model.dart';

void main() {
  runApp(const AppScaffold());
}

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppModel>(
      create: (_) => AppModel(),
      child: Builder(
        builder: (context) {
          bool touchMode = context.select((AppModel m) => m.touchMode);
          double densityAmt = touchMode ? 0.0 : -1.0;
          VisualDensity density =
              VisualDensity(horizontal: densityAmt, vertical: densityAmt);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                visualDensity: density,
                useMaterial3: true,
                colorScheme: lightColorScheme),
            darkTheme: ThemeData(
                visualDensity: density,
                useMaterial3: true,
                colorScheme: darkColorScheme),
            home: const App(title: 'Ghekko Adaptive'),
          );
        },
      ),
    );
  }
}
