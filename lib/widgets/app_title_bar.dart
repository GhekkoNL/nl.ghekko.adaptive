import 'package:adaptive/global/device_type.dart';
import 'package:adaptive/global/styling.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/app_model.dart';

class AppTitleBar extends StatelessWidget {
  const AppTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLinuxOrWindows = DeviceType.isWindows || DeviceType.isLinux;
    bool enableTouch = context.select((AppModel m) => m.touchMode);
    bool useSmallHeader = MediaQuery.of(context).size.width < 600;
    bool hideTitle = MediaQuery.of(context).size.width < 400;
    TextStyle style = useSmallHeader ? TextStyles.h2 : TextStyles.h1;
    return Material(
      child: Stack(
        children: [
          // Sets background and height for title bar
          Positioned.fill(child: Container(color: Theme.of(context).colorScheme.onPrimary)),

          // App Logo or Title
          if (hideTitle == false)
            Positioned.fill(
              child: Center(
                child: Text('Adaptive',
                    style: style.copyWith(color: Colors.white)),
              ),
            ),

          const Positioned.fill(child: SizedBox(),),

          // Enable Touch Mode Button
          Row(
            // Touch button should be right-aligned on macOS to avoid the native buttons
            textDirection:
                DeviceType.isMacOS ? TextDirection.rtl : TextDirection.ltr,
            children: [
              IconButton(
                  onPressed: () => context.read<AppModel>().toggleTouchMode(),
                  icon: Icon(enableTouch ? Icons.mouse : Icons.fingerprint)),
              const Spacer(),
            ],
          ),

          // Add window controls for Linux/Windows
          if (isLinuxOrWindows) ...[
            const Row(
              children: [
                Spacer(),
                //MinimizeWindowButton(colors: buttonColors),
                //MaximizeWindowButton(colors: buttonColors),
                //CloseWindowButton(colors: closeButtonColors),
              ],
            )
          ]
        ],
      ),
    );
  }
}

//final buttonColors = WindowButtonColors(iconNormal: Colors.white);

//final closeButtonColors = WindowButtonColors(iconNormal: Colors.white);
